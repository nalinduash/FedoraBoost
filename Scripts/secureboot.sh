#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logScriptHead "Handling SecureBoot for installing Nvidia drivers(optional)"

# Check if Secure Boot exist
logScriptSubHead "Checking if Secure Boot exist"
if [[ -d /sys/firmware/efi ]]; then
  logInfo "Secure Boot is available (UEFI detected)."
else
  logInfo "Secure Boot is unavailable (legacy BIOS). Skipping..."
  exit 0                                                            # Use exit 0 because, this is a sudo script
fi

# Check if Nvidia card exist
logScriptSubHead "Checking for pciutils(need to detect GPU card)"
installPackages "pciutils"                                              # To find GPU

logScriptSubHead "Checking if Nvidia card exist"
GPU_INFO="$(lspci -nn | grep -Ei 'VGA|Display|3D' || true)"
logData "All GPUs -->"
logData "$GPU_INFO"
HAS_NVIDIA=0
if ! echo "$GPU_INFO" | grep -qi 'NVIDIA'; then 
  HAS_NVIDIA=1; 
  logPass "No Nvdia card found. So, no need to manage the secure boot"
  exit 0
fi

# Install dependencies
logScriptSubHead "Installing dependencies"
installPackages "kmodtool"
installPackages "akmods"
installPackages "mokutil"
installPackages "openssl"

# Report current Secure Boot state (enabled/disabled)
logScriptSubHead "Checking for SecureBoot state"
sb_state="$(mokutil --sb-state 2>/dev/null || true)"
logInfo "$sb_state"

AKMODS_CERT="/etc/pki/akmods/certs/public_key.der"
needs_enroll=true

# Check if this PC already has enrolled a key (akmods MOK)
logScriptSubHead "Checking if this PC already has enrolled a key (akmods MOK)"
if [[ -f "$AKMODS_CERT" ]]; then
  logInfo "Found existing akmods public key at: $AKMODS_CERT"
  test_output="$(mokutil --test-key "$AKMODS_CERT" 2>/dev/null)"
  if echo "$test_output" | grep -q "is already enrolled"; then
    logInfo "akmods MOK is already enrolled in firmware."
    needs_enroll=false
  else
	logInfo "Key exists but is not enrolled. We can generate a new key for you."
	logHighlight "Enter Y only if you don't remember the previous password and stuck
	with a blue screen at booting the machine up"
	logHighlight "If you remember the password, enter N" 
	read -p "Do you want to forcefully enroll a new key? (y/n): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
      logInfo "Generating new akmods signing key with 'kmodgenca -a'..."
      if sudo kmodgenca -a --force; then
        logInfo "New akmods keypair generated."
        needs_enroll=true
      else
        logFail "Failed to generate new akmods keypair."
        exit 1
      fi
    else
      logInfo "Using existing key for enrollment."
      needs_enroll=true
    fi
  fi
else
  logInfo "No akmods key found. Will generate one."
fi

# If not present, generate the key
logScriptSubHead "Generating the key"
if [[ ! -f "$AKMODS_CERT" ]]; then
  read -p "No akmods key found at $AKMODS_CERT. Generate a new one? (y/n): " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    logInfo "Generating akmods signing key with 'kmodgenca -a'..."
    if sudo kmodgenca -a; then
      logInfo "akmods keypair generated."
      needs_enroll=true
    else
      logFail "Failed to generate akmods keypair."
      exit 1
    fi
  else
    logInfo "Skipping key generation as per user choice."
    exit 0
  fi
fi

# Enroll the key via MOK if not already enrolled/pending
logScriptSubHead "Enrolling the key via MOK if not already enrolled/pending"
if [[ "$needs_enroll" == true ]]; then
  clear
  br5
  logHighlight "Enrolling akmods key into MOK. You will be prompted to set a one-time password."
  logHighlight "On next boot, select 'Enroll MOK' > 'Continue' > 'Yes' and enter that password."
  br

  logInfo "Enroling"
  if sudo mokutil --import "$AKMODS_CERT"; then
    logPass "MOK enrollment request created successfully."
    logPass "Reboot required to complete enrollment via MOK Manager."
  else
    logFail "Mokutil import failed"
    exit 1
  fi
else
  logPass "MOK enrollment not required."
fi
br

# Optional guidance if Secure Boot is currently disabled
if echo "$sb_state" | grep -qi 'disabled'; then
  logHighlight "Secure Boot is currently disabled in firmware."
  logHighlight "After enrolling the MOK, enable Secure Boot in your BIOS/UEFI to enforce module signing."
fi

# Rebooting for enrollment
if [[ "$needs_enroll" == true ]]; then
  logScriptSubHead "Rebooting"
  gum confirm "Run this script again to continue"
  reboot
fi

logDone
br5
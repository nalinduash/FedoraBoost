#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Check if Secure Boot exist
if [[ -d /sys/firmware/efi ]]; then
  logInfo "Secure Boot is available (UEFI detected)."
else
  logInfo "Secure Boot is unavailable (legacy BIOS). Skipping..."
  return 0
fi

# Check if Nvidia card exist
installPackages "pciutils"                                              # To find GPU
GPU_INFO="$(lspci -nn | grep -Ei 'VGA|Display|3D' || true)"
echo "$GPU_INFO"
HAS_NVIDIA=0
if ! echo "$GPU_INFO" | grep -qi 'NVIDIA'; then 
  HAS_NVIDIA=1; 
  logPass "No Nvdia card found. So, no need to manage the secure boot"
  return 0
fi

# Install dependencies
installPackages "kmodtool"
installPackages "akmods"
installPackages "mokutil"
installPackages "openssl"

# Report current Secure Boot state (enabled/disabled)
sb_state="$(mokutil --sb-state 2>/dev/null || true)"
logInfo "$sb_state"

AKMODS_CERT="/etc/pki/akmods/certs/public_key.der"
needs_enroll=true

# Check if this PC already has enrolled a key (akmods MOK)
if [[ -f "$AKMODS_CERT" ]]; then
  logInfo "Found existing akmods public key at: $AKMODS_CERT"
  test_output="$(mokutil --test-key "$AKMODS_CERT" 2>/dev/null)"
  if echo "$test_output" | grep -q "is already enrolled"; then
    logInfo "akmods MOK is already enrolled in firmware."
    needs_enroll=false
  fi
else
  logInfo "No akmods key found. Will generate one."
fi

# If not present, generate the key
if [[ ! -f "$AKMODS_CERT" ]]; then
  read -p "No akmods key found at $AKMODS_CERT. Generate a new one? (y/n): " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    logInfo "Generating akmods signing key with 'kmodgenca -a'..."
    if sudo kmodgenca -a; then
      logInfo "akmods keypair generated."
      needs_enroll=true
    else
      logFail "Failed to generate akmods keypair."
      return 1
    fi
  else
    logInfo "Skipping key generation as per user choice."
    return 0
  fi
fi

# Enroll the key via MOK if not already enrolled/pending
if [[ "$needs_enroll" == true ]]; then
  logMessage "Enrolling akmods key into MOK. You will be prompted to set a one-time password."
  logInfo "On next boot, select 'Enroll MOK' > 'Continue' > 'Yes' and enter that password."

  if sudo mokutil --import "$AKMODS_CERT"; then
    logInfo "MOK enrollment request created successfully."
    logInfo "Reboot required to complete enrollment via MOK Manager."
  else
    logFail "mokutil import failed"
    return 1
  fi
else
  logPass "MOK enrollment not required."
fi

# Optional guidance if Secure Boot is currently disabled
if echo "$sb_state" | grep -qi 'disabled'; then
  logInfo "Secure Boot is currently disabled in firmware."
  logInfo "After enrolling the MOK, enable Secure Boot in your BIOS/UEFI to enforce module signing."
fi

# Rebooting for enrollment
logInfo "Rebooting"
gum confirm "Run this script again to continue"
sleep 5
reboot
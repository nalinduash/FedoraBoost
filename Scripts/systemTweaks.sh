#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

logScriptHead "Performing some System Tweaks";

# ======> Update core
logScriptSubHead "Updating the core of Fedora"
runCmd "sudo dnf group upgrade -y core" "Updating the core of Fedora"
 

# ======> For appimages
logScriptSubHead "Installing some apps"
installPackages "fuse"                              # To open AppImages


# ======> Media Codecs
logScriptSubHead "Installing Media Codecs"
installDnfGroup "multimedia"                                        # Video codecs through GStreamer
# Video codecs through ffmpeg
runCmd "sudo dnf swap -y 'ffmpeg-free' 'ffmpeg' --allowerasing" "Install full ffmpeg"    
# Exclude a problematic package
runCmd "sudo dnf upgrade -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin" "Exclude problematic packages"      


# ======> H/W Video Acceleration
logScriptSubHead "Installing some apps"
installPackages "pciutils"                           # To find GPU
installPackages "ffmpeg-libs"                        # Base packages
installPackages "libva"                              # Base packages
installPackages "libva-utils"                        # Base packages

# Detect GPUs
logScriptSubHead "Detecting GPUs..."
GPU_INFO="$(lspci -nn | grep -Ei 'VGA|Display|3D' || true)"
logData "$GPU_INFO"
HAS_INTEL=0
HAS_AMD=0
if echo "$GPU_INFO" | grep -qi 'Intel'; then HAS_INTEL=1; fi
if echo "$GPU_INFO" | grep -qi 'AMD'; then HAS_AMD=1; fi

# Intel setup
logScriptSubHead "Installing drivers for Intel"
if (( HAS_INTEL )); then
  logInfo "Found an Intel GPU"
  runCmd "sudo dnf swap -y libva-intel-media-driver intel-media-driver --allowerasing" "Installing Intel drivers..."
  runCmd "sudo dnf install -y libva-intel-driver" "Installing Intel legacy drivers..."
else
  logPass "No Intel GPU detected; skipping Intel-specific setup."
fi

# AMD setup
logScriptSubHead "Installing drivers for AMD"
if (( HAS_AMD )); then
  logInfo "Found an AMD GPU"
  # 64-bit swaps
  runCmd "sudo dnf swap -y --allowerasing mesa-va-drivers mesa-va-drivers-freeworld" "Installing 64-bit mesa va drivers..."
  runCmd "sudo dnf swap -y --allowerasing mesa-vdpau-drivers mesa-vdpau-drivers-freeworld" "Installing 64-bit mesa vdpau drivers..."
  # 32-bit swaps
  runCmd "sudo dnf swap -y --allowerasing mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686" "Installing 32-bit mesa va drivers..."
  runCmd "sudo dnf swap -y --allowerasing mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686" "Installing 32-bit mesa vdpau drivers.."
else
  logPass "No AMD GPU detected; skipping AMD-specific swaps."
fi


# ======> Set UTC Time for dual boots
logScriptSubHead "Setting UTC Time for dual boots"
runCmd "sudo timedatectl set-local-rtc '0'" "Setting UTC time"


# ======> Speed up
logScriptSubHead "Speeding up the system"
runCmd "sudo systemctl disable NetworkManager-wait-online.service" "Speed up the boot time by disabaling NetworkManager-wait-online.service"

logDone
br5
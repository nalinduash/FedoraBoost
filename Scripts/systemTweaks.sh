#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;


# Update core
logInfo "Update the core of Fedora"
sudo dnf group upgrade -y core


# Update firmware
logInfo "Update firmware"
sudo fwupdmgr refresh --force
if sudo fwupdmgr update -y; then
    logPass "Firmware updated successfully"
else
    logFail "Firmware update failed"
fi


# For appimages
installPackages "fuse"                              # To open AppImages
installFlatpakPackage "it.mijorus.gearlever"        # Manage AppImages


# Media Codecs
installDnfGroup "Multimedia"                                        # Video codecs through GStreamer

if sudo dnf swap -y 'ffmpeg-free' 'ffmpeg' --allowerasing; then     # Video codecs through ffmpeg
    logPass "Full ffmpeg is installed"
else
    logFail "Full ffmpeg is not installed"
fi

sudo dnf upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin       # Exclude a problematic package

installDnfGroup "sound-and-video"                                   


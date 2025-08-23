#!/bin/bash

# Importing SH files
source ./Scripts/common.sh



logInfo "Installing common apps through DNF"

installPackages "libreoffice"                           # Office suit
installPackages "ark"                                   # Compress and decompress files
installPackages "obs-studio"                            # Record screen and stream
installPackages "kmod-v4l2loopback"                     # Virtual camera support for Obs-studio



logInfo "Installing common apps through Flatpak"
installFlatpakPackage "us.zoom.Zoom"                    # Online meeting app
installFlatpakPackage "io.missioncenter.MissionCenter"  # System monitor
installFlatpakPackage "it.mijorus.gearlever"            # Manage AppImages


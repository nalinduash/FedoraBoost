#!/bin/bash

# Importing SH files
source ./Scripts/common.sh



logInfo "Installing common apps through DNF"

installPackages "libreoffice"
installPackages "ark"



logInfo "Installing common apps through Flatpak"
installFlatpakPackage "us.zoom.Zoom"
installFlatpakPackage "io.missioncenter.MissionCenter"


#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logInfo "Installing Repos";
sudo bash ./Scripts/dependencies/repos.sh              # Install repositories

logInfo "Installing Packages"
sudo bash ./Scripts/dependencies/packages.sh             # Install packages through dnf

logInfo "Installing pip packages"
source ./Scripts/dependencies/pip.sh                     # Install packages through python-3 pip       

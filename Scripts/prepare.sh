#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logScriptHead "Starting customization...";

# Adding some needed packages for the installation
logScriptSubHead "Adding some needed packages for the installation"
installPackages "curl"
installPackages "gum"

# Stop sleeping and locking during the installation
logScriptSubHead "Stopping auto-sleeping"
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

# Speedup DNF installation
logScriptSubHead "Speeding-up DNF"
add_configs "/etc/dnf/dnf.conf" "max_parallel_downloads=10"
add_configs "/etc/dnf/dnf.conf" "fastestmirror=True"

# Enabaling RPM fusion Repos
logScriptSubHead "Enabaling RPM fusion Repos";
source ./Scripts/repos.sh;

# Update system
logScriptSubHead "Updating the system";
sudo dnf update && sudo dnf upgrade 

logDone
br5
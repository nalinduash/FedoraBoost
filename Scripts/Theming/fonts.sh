#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Install oh-my-posh 
logScriptMiniSubHead "Installing oh-my-posh" 
if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
    logPassInstall "oh-my-posh"
else
    logAlreadyInstall "oh-my-posh"
fi

# Downloading fonts
logScriptMiniSubHead "Downloading fonts"
installPackages "jetbrains-mono-fonts-all"

# Setting fonts in gnome
logScriptMiniSubHead "Applying fonts"
gsettings set org.gnome.desktop.interface font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface document-font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrains Mono Regular 12"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Adwaita Sans SemiBold 11"

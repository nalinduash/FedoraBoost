#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Install oh-my-posh 
if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
    logPassInstall "oh-my-posh"
else
    logAlreadyInstall "oh-my-posh"
fi

# Downloading fonts
oh-my-posh font install JetBrainsMono

# Setting fonts in gnome
gsettings set org.gnome.desktop.interface font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface document-font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Regular 12"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Adwaita Sans SemiBold 11"
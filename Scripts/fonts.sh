#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Downloading fonts
oh-my-posh font install JetBrainsMono

# Setting fonts in gnome
gsettings set org.gnome.desktop.interface font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface document-font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Regular 12"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Adwaita Sans SemiBold 11"
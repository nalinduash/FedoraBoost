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
 
installFonts() {
    # Loop through each font
    for font in "$@"; do
        # Use fc-list to check if font is already installed (case-insensitive)
        if fc-list | grep -iq "$font"; then
        logPass "$font font is already installed."
        else
        logInfo "Installing $font..."
        if oh-my-posh font install "$font"; then
            logPass "$font font installed successfully."
        else
            logFail "Failed to install $font font."
            exit 1;
        fi
        fi
    done
}

# Downloading fonts
logScriptMiniSubHead "Downloading fonts"
installFonts "JetBrainsMono"

# Setting fonts in gnome
logScriptMiniSubHead "Applying fonts"
gsettings set org.gnome.desktop.interface font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface document-font-name "Adwaita Sans Regular 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Regular 12"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Adwaita Sans SemiBold 11"
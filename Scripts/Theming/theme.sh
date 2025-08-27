#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Variables
REPO_URL="https://github.com/EliverLara/Nordic.git"
INSTALL_DIR="$HOME/.themes"
TEMP_DIR="./Temp/Nordic"

# Check if theme already installed
current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d \')
if [[ $current_theme == "Nordic" ]]; then
    logAlreadyInstall "Nordic GTK theme"
    return 
fi

# Step 1: Dependencies (GNOME dev lib for GTK on Fedora)
logScriptMiniSubHead "Installing some dependencies"
installPackages gtk-murrine-engine 
installPackages gtk2-engines

# Step 2: Clone repo 
logScriptMiniSubHead "Cloning the repo"
mkdir -p "$TEMP_DIR"
mkdir -p "$INSTALL_DIR"
delete_folder_if_exists "$TEMP_DIR"
git clone --depth=1 "$REPO_URL" "$TEMP_DIR"

# Step 3: Install 
logScriptMiniSubHead "Installing"
delete_folder_if_exists "$INSTALL_DIR/Nordic"*
cp -r "$TEMP_DIR" "$INSTALL_DIR"


# Apply GTK theme for GNOME immediately
logScriptMiniSubHead "Applying the GTK theme"
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"

# Cleaning up
logScriptMiniSubHead "Cleaning up"
delete_folder_if_exists "$TEMP_DIR" 
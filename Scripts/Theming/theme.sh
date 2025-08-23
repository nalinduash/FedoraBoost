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
    logPass "Skipping..."
    return 0
fi

# Step 1: Dependencies (GNOME dev lib for GTK on Fedora)
installPackages gtk-murrine-engine 
installPackages gtk2-engines

# Step 2: Clone repo 
mkdir -p "$TEMP_DIR"
mkdir -p "$INSTALL_DIR"
rm -rf "$TEMP_DIR"
git clone --depth=1 "$REPO_URL" "$TEMP_DIR"

# Step 3: Install 
rm -rf "$INSTALL_DIR/Nordic"*
cp -r "$TEMP_DIR" "$INSTALL_DIR"


# Apply GTK theme for GNOME immediately
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"

# Cleaning up
rm -rf "$TEMP_DIR" 
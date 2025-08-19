#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

# Constants
REPO_URL="https://github.com/vinceliuice/Graphite-cursors.git"
INSTALL_DIR="$HOME/.local/share/icons"
DEFAULT_THEME_NAME="Graphite-dark-nord-cursors"
TEMP_DIR="./Temp/Cursor/"

# Check if the theme already applied
if gsettings set org.gnome.desktop.interface cursor-theme "$DEFAULT_THEME_NAME"; then
    return
fi

# Clone repo
logInfo "Cloning repo into $TEMP_DIR"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

# Remove if already exists
logInfo "Removing if already exists"
rm -rf $INSTALL_DIR/Graphite-light-nord-cursors
rm -rf $INSTALL_DIR/Graphite-dark-nord-cursors

# Install
logInfo "Installing"
cp -r "$TEMP_DIR/dist-light-nord" $INSTALL_DIR/Graphite-light-nord-cursors
cp -r "$TEMP_DIR/dist-dark-nord" $INSTALL_DIR/Graphite-dark-nord-cursors

# Set the cursor theme in GNOME
logInfo "Setting cursor theme to Graphite-Cursors"
gsettings set org.gnome.desktop.interface cursor-theme "$DEFAULT_THEME_NAME"

# Cleaning up
logInfo "Cleaning up"
rm -rf "./Temp/Cursor/"
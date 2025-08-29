#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

# Constants
REPO_URL="https://github.com/vinceliuice/Graphite-cursors.git"
INSTALL_DIR="$HOME/.local/share/icons"
DEFAULT_THEME_NAME="Graphite-dark-nord-cursors"
TEMP_DIR="./Temp/Cursor/"

# Get current theme
current_theme=$(gsettings get org.gnome.desktop.interface cursor-theme | tr -d "'")

# Check if the theme already applied
if [[ "$current_theme" == "$DEFAULT_THEME_NAME" ]]; then
    echo "Cursor theme already set to $DEFAULT_THEME_NAME"
    return 0
fi

# Clone repo
logScriptMiniSubHead "Cloning repo into $TEMP_DIR"
delete_folder_if_exists "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

# Remove if already exists
logScriptMiniSubHead "Removing if already exists"
delete_folder_if_exists "$INSTALL_DIR/Graphite-light-nord-cursors"
delete_folder_if_exists "$INSTALL_DIR/Graphite-dark-nord-cursors"

# Install
logScriptMiniSubHead "Installing cursor theme"
cp -r "$TEMP_DIR/dist-light-nord" $INSTALL_DIR/Graphite-light-nord-cursors
cp -r "$TEMP_DIR/dist-dark-nord" $INSTALL_DIR/Graphite-dark-nord-cursors

# Set the cursor theme in GNOME
logScriptMiniSubHead "Setting cursor theme to Graphite-Cursors"
gsettings set org.gnome.desktop.interface cursor-theme "$DEFAULT_THEME_NAME"

# Cleaning up
logScriptMiniSubHead "Cleaning up"
delete_folder_if_exists "./Temp/Cursor/"
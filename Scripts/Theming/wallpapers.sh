#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Hardcoded paths
SRC="./Assets/Wallpapers"
DEST="$HOME/.local/share/backgrounds/nalindu-dotfiles"

# Create destination folder if not exists
logScriptMiniSubHead "Creating destination folder if not exists"
mkdir -p "$DEST"

# Copy all wallpapers
logScriptMiniSubHead "Copying all wallpapers"
cp -f "$SRC"/* "$DEST"/

# Full path to the target wallpaper
TARGET="$DEST/Background"
URI="file://$TARGET"

# Set GNOME wallpaper (light & dark)
logScriptMiniSubHead "Setting GNOME wallpaper"
gsettings set org.gnome.desktop.background picture-uri "$URI-13.png"
gsettings set org.gnome.desktop.background picture-uri-dark "$URI-13.png"

logPass "Wallpapers successfully added"
#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Hardcoded paths
SRC="./Assets/Wallpapers"
DEST="$HOME/.local/share/backgrounds"

# Create destination folder if not exists
mkdir -p "$DEST"

# Copy all wallpapers
cp -f "$SRC"/* "$DEST"/

# Full path to the target wallpaper
TARGET="$DEST/Background"
URI="file://$TARGET"

# Set GNOME wallpaper (light & dark)
gsettings set org.gnome.desktop.background picture-uri "$URI-1.png"
gsettings set org.gnome.desktop.background picture-uri-dark "$URI-2.png"

logPass "Wallpapers successfully added"
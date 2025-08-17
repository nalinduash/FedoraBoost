#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Hardcoded paths
SRC="./Assets/Wallpapers"
DEST="$HOME/.local/share/backgrounds"
WALL="Background1.jpg"

# Create destination folder if not exists
mkdir -p "$DEST"

# Copy all wallpapers
cp -f "$SRC"/* "$DEST"/

# Full path to the target wallpaper
TARGET="$DEST/$WALL"
URI="file://$TARGET"

# Set GNOME wallpaper (light & dark)
gsettings set org.gnome.desktop.background picture-uri "$URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$URI"

logpass "Wallpapers successfully added"
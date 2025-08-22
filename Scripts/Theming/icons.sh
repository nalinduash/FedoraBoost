#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Variables
REPO_URL="https://github.com/vinceliuice/Tela-icon-theme.git"
TEMP_DIR="./Temp/Icons"
THEME="brown"

# Step 1: Install required dependencies
installPackages unzip 
installPackages wget

# Step 2: Clone repo fresh
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
git clone --depth=1 "$REPO_URL" "$TEMP_DIR"

# Step 3: Install 
cd "$TEMP_DIR"
./install.sh "$THEME" 

# Update Icon cache
for theme_dir in "$INSTALL_DIR"/Tela-"$THEME"*; do
    if [ -d "$theme_dir" ]; then
        sudo gtk-update-icon-cache -f -q "$theme_dir" || true
    fi
done

# Applying the icon theme
gsettings set org.gnome.desktop.interface icon-theme "Tela-$THEME"

# Cleaning up
rm -rf "$TEMP_DIR"  
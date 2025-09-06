#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Variables
REPO_URL="https://github.com/vinceliuice/Tela-icon-theme.git"
TEMP_DIR="./Temp/Icons"
THEME="brown"

current_theme=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
if [[ $current_theme == "Tela-$THEME" ]]; then
    logAlreadyInstall "Tela Icon theme"
    return 0
fi

# Step 1: Install required dependencies
logScriptMiniSubHead "Installing some packages"
installPackages unzip 
installPackages wget

# Step 2: Clone repo fresh
logScriptMiniSubHead "Cloning the repo"
br
delete_folder_if_exists "$TEMP_DIR"
clone_repo "$REPO_URL" "$TEMP_DIR" "Tela Icon Theme"
br

# Step 3: Install 
logScriptMiniSubHead "Installing"
$TEMP_DIR/install.sh "$THEME" 

# Update Icon cache
logScriptMiniSubHead "Updating Icon cache"
for theme_dir in "$INSTALL_DIR"/Tela-"$THEME"*; do
    if [ -d "$theme_dir" ]; then
        sudo gtk-update-icon-cache -f -q "$theme_dir" || true
    fi
done

# Applying the icon theme
logScriptMiniSubHead "Applying the icon theme"
gsettings set org.gnome.desktop.interface icon-theme "Tela-$THEME"

# Cleaning up
logScriptMiniSubHead "Cleaning up"
delete_folder_if_exists "$TEMP_DIR"  
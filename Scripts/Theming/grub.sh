#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

# Vimix theme repo
THEME_REPO="https://github.com/vinceliuice/grub2-themes.git"
THEME_NAME="vimix"
TEMP_DIR="./Temp/GRUB/"

# Check if theme already installed
if [[ -f "/boot/grub2/themes/$THEME_NAME/theme.txt" ]]; then
    logAlreadyInstall "Vimix theme"
    exit 0                                                      # Use exit instead of return because, this script is running as sudo
fi

logScriptMiniSubHead "Installing some packages"
installPackages grub2-tools

# Clone repo
logScriptMiniSubHead "Cloning repo into $TEMP_DIR"
delete_folder_if_exists "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
git clone --depth=1 "$THEME_REPO" "$TEMP_DIR"

logScriptMiniSubHead "Installing theme into /boot/grub2/themes/$THEME_NAME..."
mkdir -p /boot/grub2/themes
"$TEMP_DIR/install.sh" -b -t "$THEME_NAME" -i white

# Cleaning up
logScriptMiniSubHead "Cleaning up"
delete_folder_if_exists "$TEMP_DIR"  
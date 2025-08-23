#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

# Vimix theme repo
THEME_REPO="https://github.com/vinceliuice/grub2-themes.git"
THEME_NAME="vimix"
TEMP_DIR="./Temp/GRUB/"

# Check if theme already installed
if [ -f "/boot/grub2/themes/$THEME_NAME/theme.txt" ]; then
    logAlreadyInstall "Vimix theme"
    logPass "Skipping..."
    return 0
fi

installPackages grub2-tools

# Clone repo
logInfo "Cloning repo into $TEMP_DIR"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
git clone --depth=1 "$THEME_REPO" "$TEMP_DIR"

logInfo "Installing theme into /boot/grub2/themes/$THEME_NAME..."
sudo mkdir -p /boot/grub2/themes
sudo "$TEMP_DIR/install.sh" -b -t "$THEME_NAME" -i white

logPass "Vimix GRUB theme installed successfully!"
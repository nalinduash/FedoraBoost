#!/bin/bash

# Make every .sh file executable
find . -name "*.sh" -type f -exec chmod +x {} \; -print

# Importing SH files
source ./Scripts/common.sh;

# Create log files
mkdir -p $log_dir
touch $log_path

# Clear the screen
clear

# Check if script is running with sudo privileges
if [[ $EUID -eq 0 ]]; then
    logError "This script should not run with sudo privileges.\nPlease run it as a normal user";
    exit 1
fi

# Cache the sudo privilages so, user only need to enter password one time.
logHighlight "Enter your password to begin customizations..."
sudo -v

# Keep sudo credentials alive in the background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Clear the screen
clear

# Display the ASCII art
echo -e "\e[36m _        _______  _       _________ _        ______               " | tee -a $log_path;                  
echo -e "( (    /|(  ___  )( \      \__   __/( (    /|(  __  \ |\     /|          " | tee -a $log_path; 
echo -e "|  \  ( || (   ) || (         ) (   |  \  ( || (  \  )| )   ( |          " | tee -a $log_path;
echo -e "|   \ | || (___) || |         | |   |   \ | || |   ) || |   | |          " | tee -a $log_path;
echo -e "| (\ \) ||  ___  || |         | |   | (\ \) || |   | || |   | |          " | tee -a $log_path;
echo -e "| | \   || (   ) || |         | |   | | \   || |   ) || |   | |          " | tee -a $log_path;
echo -e "| )  \  || )   ( || (____/\___) (___| )  \  || (__/  )| (___) |          " | tee -a $log_path;
echo -e "|/    )_)|/     \|(_______/\_______/|/    )_)(______/ (_______)          " | tee -a $log_path;
echo -e "                                                                         " | tee -a $log_path;
echo -e " ______   _______ _________ _______ _________ _        _______  _______  " | tee -a $log_path;
echo -e "(  __  \ (  ___  )\__   __/(  ____ \\__   __/( \      (  ____ \(  ____ \ " | tee -a $log_path;
echo -e "| (  \  )| (   ) |   ) (   | (    \/   ) (   | (      | (    \/| (    \/ " | tee -a $log_path;
echo -e "| |   ) || |   | |   | |   | (__       | |   | |      | (__    | (_____  " | tee -a $log_path;
echo -e "| |   | || |   | |   | |   |  __)      | |   | |      |  __)   (_____  ) " | tee -a $log_path;
echo -e "| |   ) || |   | |   | |   | (         | |   | |      | (            ) | " | tee -a $log_path;
echo -e "| (__/  )| (___) |   | |   | )      ___) (___| (____/\| (____/\/\____) | " | tee -a $log_path;
echo -e "(______/ (_______)   )_(   |/       \_______/(_______/(_______/\_______)\e[0m" | tee -a $log_path;

# Warning
logWarning "This script will overwrite your existing configuration files. 🫤\nI will backup your existing configuration files to '$backup_dir' folder in the home directory. 😇";

# Ask if they want to continue
read -p "Do you want to continue? (y/N): " response

# Convert response to lowercase
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

# Check if user wants to continue
if [[ "$response" != "y" && "$response" != "yes" ]]; then
    logMessage "Customization cancelled.";
    exit 0;
fi    
    
# ====================Start======================
clear;
# Prepare system to run this script
#source ./Scripts/prepare.sh; 

# Secure boot
#sudo ./Scripts/secureboot.sh               # Need sudo privilages here

# Select Apps
source ./Scripts/selectApps.sh;

# Installing Nvidia drivers
#source ./Scripts/nvidia.sh;

# Adding Shortcut key combinations
#source ./Scripts/shortcuts.sh; 

# Some system tweaks
#source ./Scripts/systemTweaks.sh; 

# Theming Desktop
#source ./Scripts/theming.sh; 

# Install Apps
source ./Scripts/apps.sh "$appfile";


# ===================END=======================
# Enable default sleeping and locking behaviour
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300
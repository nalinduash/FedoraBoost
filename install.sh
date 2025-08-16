#!/bin/bash

# Exit immediately if a command exits with a non-zero value
set -e

# Make every .sh file executable
find . -name "*.sh" -type f -exec chmod +x {} \; -print

# Importing SH files
source ./Scripts/common.sh;

# Clear the screen
clear

# Check if script is running with sudo privileges
if [[ $EUID -eq 0 ]]; then
    logError "This script should not run with sudo privileges.\nPlease run it as a normal user";
    exit 1
fi

# Clear the screen
clear

# Display the ASCII art
echo -e "\e[36m _        _______  _       _________ _        ______               ";                  
echo -e "( (    /|(  ___  )( \      \__   __/( (    /|(  __  \ |\     /|          "; 
echo -e "|  \  ( || (   ) || (         ) (   |  \  ( || (  \  )| )   ( |          ";
echo -e "|   \ | || (___) || |         | |   |   \ | || |   ) || |   | |          ";
echo -e "| (\ \) ||  ___  || |         | |   | (\ \) || |   | || |   | |          ";
echo -e "| | \   || (   ) || |         | |   | | \   || |   ) || |   | |          ";
echo -e "| )  \  || )   ( || (____/\___) (___| )  \  || (__/  )| (___) |          ";
echo -e "|/    )_)|/     \|(_______/\_______/|/    )_)(______/ (_______)          ";
echo -e "                                                                         ";
echo -e " ______   _______ _________ _______ _________ _        _______  _______  ";
echo -e "(  __  \ (  ___  )\__   __/(  ____ \\__   __/( \      (  ____ \(  ____ \ ";
echo -e "| (  \  )| (   ) |   ) (   | (    \/   ) (   | (      | (    \/| (    \/ ";
echo -e "| |   ) || |   | |   | |   | (__       | |   | |      | (__    | (_____  ";
echo -e "| |   | || |   | |   | |   |  __)      | |   | |      |  __)   (_____  ) ";
echo -e "| |   ) || |   | |   | |   | (         | |   | |      | (            ) | ";
echo -e "| (__/  )| (___) |   | |   | )      ___) (___| (____/\| (____/\/\____) | ";
echo -e "(______/ (_______)   )_(   |/       \_______/(_______/(_______/\_______)\e[0m";

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
    
# Start
clear;
logMessage "Starting customization...";

# Stop sleeping and locking during the installation
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

# Update system
logInfo "1 - Updating the system";
sudo dnf update && sudo dnf upgrade

# Installing Dependencies
logInfo "2 - Installing Dependencies";
source ./Scripts/dependencies.sh;    

# Installing Fish Shell and customizing it
logInfo "3 - Installing Fish Shell and customizing it";
source ./Scripts/fish.sh; 

# Installing Gnome Shell Extensions
logInfo "4 - Installing Gnome Shell extensions";
source ./Scripts/extensions.sh; 



# Enable default sleeping and locking behaviour
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300
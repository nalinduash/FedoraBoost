#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

# Installing Fish Shell and customizing it
logInfo "Installing Fish Shell and customizing it";
source ./Scripts/Theming/fish.sh; 

# Installing Gnome Shell Extensions
logInfo "Installing Gnome Shell extensions";
source ./Scripts/Theming/extensions.sh; 

# Change Gnome settings
logInfo "Changing Gnome settings";
source ./Scripts/Theming/gnome_settings.sh; 

# Fonts
logInfo "Adding fonts";
source ./Scripts/Theming/fonts.sh; 

# Wallpapers
logInfo "Adding wallpapers";
source ./Scripts/Theming/wallpapers.sh; 

# Cursor
logInfo "Adding cursor";
source ./Scripts/Theming/cursor.sh; 
#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

logScriptHead "Customizing the desktop for a better user experience"

# Installing Fish Shell and customizing it
logScriptSubHead "Installing Fish Shell and customizing it";
source ./Scripts/Theming/fish.sh; 

# Wallpapers
logScriptSubHead "Adding wallpapers";
source ./Scripts/Theming/wallpapers.sh; 

# Installing Gnome Shell Extensions
logScriptSubHead "Installing Gnome Shell extensions";
source ./Scripts/Theming/extensions.sh; 

# Change Gnome settings
logScriptSubHead "Changing Gnome settings";
source ./Scripts/Theming/gnome_settings.sh; 

# Fonts
logScriptSubHead "Adding fonts";
source ./Scripts/Theming/fonts.sh; 

# Cursor
logScriptSubHead "Adding cursor";
source ./Scripts/Theming/cursor.sh; 

# Icons
logScriptSubHead "Adding Icons";
source ./Scripts/Theming/icons.sh;

# Theme
logScriptSubHead "Adding Theme";
source ./Scripts/Theming/theme.sh;

# GRUB
logScriptSubHead "Adding GRUB theme";
sudo ./Scripts/Theming/grub.sh;

logDone
br5
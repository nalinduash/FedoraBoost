#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Save backup data
source "$settings_backup"

logScriptHead "Finishing the Script";

# Restore the sleeping and locking behaviour
logScriptSubHead "Restoring the sleeping and locking behaviour"
gsettings set org.gnome.desktop.screensaver lock-enabled "$LOCK_ENABLED"
gsettings set org.gnome.desktop.session idle-delay "$IDLE_DELAY"

logHighlight "Script was installed successfully"
logHighlight "Now it is highly recommended to restart your computer."
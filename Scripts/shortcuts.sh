#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

logInfo "Adding shortcuts";

# Add gnome's default shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']" 
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"

# Custom Shortcuts
add_shortcut_if_missing "Ulauncher" "ulauncher-toggle" "<Control>space"
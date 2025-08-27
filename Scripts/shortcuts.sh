#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

logScriptHead "Adding Shortcut key combinations";

# Add gnome's default shortcuts
logScriptSubHead "Adding Gnome shortcuts"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']" 
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"

# Custom Shortcuts
logScriptSubHead "Adding Custom Shortcuts"
logScriptMiniSubHead "Adding ulauncher shortcut"
add_shortcut_if_missing "Ulauncher" "ulauncher-toggle" "<Control>space"

logDone
br5
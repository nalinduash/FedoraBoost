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


logDone
br5
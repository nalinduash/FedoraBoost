#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Add minimize and maximize buttons
logScriptMiniSubHead "Adding minimize,maximize,close buttons"
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"


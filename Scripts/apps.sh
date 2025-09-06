#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logScriptHead "Installing Apps"

logScriptSubHead "Installing common apps"
source "./Scripts/Apps/commonApps.sh"

logScriptSubHead "Installing apps with customizations"
source "./Scripts/Apps/vlc.sh"
source "./Scripts/Apps/ulauncher.sh"

logDone
br5
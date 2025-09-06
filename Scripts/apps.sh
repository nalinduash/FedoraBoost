#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logScriptHead "Installing Apps"

logScriptSubHead "Installing common apps"
source "./Scripts/Apps/commonApps.sh"

logScriptSubHead "Installing common apps with customizations"
source "./Scripts/Apps/vlc.sh"
source "./Scripts/Apps/ulauncher.sh"


#Installing user's app selection
if [ $# -ne 1 ]; then
  logError "No app selection file passed"
  exit 1
fi

appfile="$1"

if [ ! -s "$appfile" ]; then
  logWarning "No apps to install!"
  exit 1
fi

logScriptSubHead "Installing applications from user's choice..."
for pkg in $(cat "$appfile"); do
  installPackages "$pkg"
done

logDone
br5
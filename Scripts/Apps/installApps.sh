#!/bin/bash

# Importing SH files
source ./Scripts/common.sh
source ./Scripts/Apps/appInstallationScript.sh

logScriptHead "Installing Apps"

logScriptSubHead "Installing common apps"
source "./Scripts/Apps/commonApps.sh"


#Installing user's app selection
if [ $# -ne 1 ]; then
  logError "No app selection file passed"
  exit 1
fi

appfile="$1"

if [ ! -s "$appfile" ]; then
  logError "Could not find the app-selection.txt"
  exit 1
fi

logScriptSubHead "Installing applications from user's choice..."
for pkg in $(cat "$appfile"); do
  func_name="install_"$pkg
  $func_name
done

rm ./app-selection.txt

br
logDone
br5
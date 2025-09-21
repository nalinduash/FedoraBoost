#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

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
  if [[ $pkg == "Zoom" ]]; then
	installFlatpakPackage "us.zoom.Zoom" "Zoom"									              # Online meeting app
  elif [[ $pkg == "Mission-Center" ]]; then
	installFlatpakPackage "io.missioncenter.MissionCenter" "Mission Center"  				  # System monitor
  elif [[ $pkg == "Gear-Lever" ]]; then
	installFlatpakPackage "it.mijorus.gearlever" "Gear Lever"           	  				  # Manage AppImages
  elif [[ $pkg == "VLC" ]]; then
    source "./Scripts/Apps/vlc.sh"
  elif [[ $pkg == "Ulauncher" ]]; then
    source "./Scripts/Apps/ulauncher.sh"
  elif [[ $pkg == "Etcher" ]]; then
    source "./Scripts/Apps/etcher.sh"
  else
    installPackages "$pkg"
  fi
done

rm ./app-selection.txt

br
logDone
br5
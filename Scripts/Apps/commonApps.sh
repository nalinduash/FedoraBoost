#!/bin/bash

# Importing SH files
source ./Scripts/common.sh


logScriptMiniSubHead "Installing common dependencies through DNF"
installPackages "yt-dlp"								# Help to video-downloader 


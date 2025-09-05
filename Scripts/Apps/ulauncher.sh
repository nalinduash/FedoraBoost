#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logScriptMiniSubHead "ulauncher"
installPackages "ulauncher"

logMiniInfo "Adding ulauncher shortcut"
add_shortcut_if_missing "Ulauncher" "ulauncher-toggle" "<Control>space"

logMiniInfo "Adding ulauncher to Startup Applications"
mkdir -p ~/.config/autostart/
cp "./Assets/Configs/ulauncher/ulauncher.desktop" "$HOME/.config/autostart/ulauncher.desktop"

logMiniInfo "Customizing Ulauncher"
gtk-launch ulauncher.desktop >/dev/null 2>&1
sleep 2                                         # Wait till ulauncher setup it's defaults
cp "./Assets/Configs/ulauncher/ulauncher.json" "$HOME/.config/ulauncher/settings.json"

logMiniInfo "Adding extensions"
clone_repo "https://github.com/Ulauncher/ulauncher-emoji.git" "$HOME/.local/share/ulauncher/extensions/com.github.ulauncher.ulauncher-emoji/"
clone_repo "https://github.com/manahter/ulauncher-translate.git" "$HOME/.local/share/ulauncher/extensions/com.github.manahter.ulauncher-translate/"
clone_repo "https://github.com/iboyperson/ulauncher-system.git" "$HOME/.local/share/ulauncher/extensions/com.github.iboyperson.ulauncher-system/"
clone_repo "https://github.com/DevKleber/ulauncher-open-link.git" "$HOME/.local/share/ulauncher/extensions/com.github.devkleber.ulauncher-open-link/"
clone_repo "https://github.com/NastuzziSamy/ulauncher-google-search.git" "$HOME/.local/share/ulauncher/extensions/com.github.nastuzzisamy.ulauncher-google-search/"

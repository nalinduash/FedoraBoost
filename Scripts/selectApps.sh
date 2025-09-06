#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logScriptHead "Selecting apps to be installed..."

# Categories and apps
declare -A categories
categories=(
  ["Developer"]="git vim python3 python3-pip nodejs npm"
  ["Productivity"]="libreoffice "
  ["Normal User"]=""
  ["Creative"]="gimp inkscape blender krita audacity obs-studio kdenlive"
  ["System Tools"]="btop gparted curl wget"
  ["Gamer"]="lutris"
)

while true; do
    logScriptSubHead "Select one or more categories (press Space to select, Enter to confirm):"
    mapfile -t selected_categories < <(printf "%s\n" "${!categories[@]}" | gum choose --no-limit)

    # Build app list (with duplicates possible)
    app_list=()
    for category in "${selected_categories[@]}"; do
        for app in ${categories["$category"]}; do
            app_list+=("$app")
        done
    done

    # Remove duplicates
    unique_apps=($(printf "%s\n" "${app_list[@]}" | sort -u))

    # Let user prune apps
    logScriptSubHead "You selected apps. Remove any apps you don't want (use ↑/↓ and Ctrl+K to remove lines, Enter to confirm):"
    mapfile -t final_apps < <(printf "%s\n" "${unique_apps[@]}" | gum choose --no-limit)

    br
    logInfo "Final app list:"
    printf " - %s\n" "${final_apps[@]}"
    br

    # Ask if satisfied
    if gum confirm "Do you want to continue with this list?"; then
        break
    else
        logInfo "Okay, lets try again..."
    fi
done

# Save to file
printf "%s\n" "${final_apps[@]}" > "$appfile"

logDone
br5

#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

installPackages "vlc"


# Changing the config file
mkdir -p "$HOME/.config/vlc/"
delete_file_if_exists "$HOME/.config/vlc/vlcrc"
cp "./Assets/Configs/vlc/vlcrc" "$HOME/.config/vlc/"


# Installing extensions
curl -Lfs https://addons.videolan.org/p/1154030/loadFiles \
| jq -r '.files[] | select(.name=="shuffle.lua") | .url' \
| perl -pe 's/%(\w\w)/chr hex $1/ge' \
| xargs wget -q -P ./Temp
mkdir -p "$HOME/.local/share/vlc/lua/extensions/"
delete_file_if_exists "$HOME/.local/share/vlc/lua/extensions/shuffle.lua"
mv "./Temp/shuffle.lua" "$HOME/.local/share/vlc/lua/extensions/"
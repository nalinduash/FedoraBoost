#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

install_Git(){
	logScriptMiniSubHead "Git - Version controlling system"
	installPackages "git"
}

install_Visual_studio_code(){
	logScriptMiniSubHead "Visual Studio Code - Free coding IDE"
	# Install the key and yum repository for VS-Code
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
	
	installPackages "code"
}

install_Video_downloader(){
	logScriptMiniSubHead "Video Downloader - Video Downloader that support over 1000 sites"
	installPackages "video-downloader"
}

install_Mission_center(){
	logScriptMiniSubHead "Mission Center - System monitor"
	installFlatpakPackage "io.missioncenter.MissionCenter"
}

install_Gear_lever(){
	logScriptMiniSubHead "Gear Lever - Manage AppImage files"
	installFlatpakPackage "it.mijorus.gearlever"
}

install_Etcher(){
	logScriptMiniSubHead "Etcher - Used to flash USB"

	REPO="balena-io/etcher"
	TMP_FILE="./Temp/balena-etcher.rpm"
	APP_NAME="balena-etcher"

	local_version=$(get_local_version "$APP_NAME")

	latest_url=$(get_latest_url "$REPO")
	if [[ -z "$latest_url" ]]; then
		logError "Could not find latest .rpm release URL."
		exit 1
	fi

	latest_version=$(get_latest_version_from_url "$latest_url")

	if [[ -n "$local_version" ]]; then
		if [[ "$local_version" == "$latest_version" ]]; then
			logAlreadyInstall "Etcher"
			return 0
		else
			logInfo "New version available for Etcher."
		fi
	fi

	curl -L "$latest_url" -o "$TMP_FILE" &>/dev/null &
	INSTALL_PID=$!
	spinner "$INSTALL_PID" "Downloading Etcher"

	wait "$INSTALL_PID"
	if [[ $? -eq 0 ]]; then
	logPass "$APP_NAME is successfully downloaded"
	else
	logFail "$APP_NAME is failed to download"
	return 1
	fi

	installPackages "$TMP_FILE"

	rm -f "$TMP_FILE"
}

install_ULauncher(){
	logScriptMiniSubHead "Ulauncher - Powerfull launcher"
	installPackages "ulauncher"

	logMiniInfo "Adding ulauncher shortcut"
	add_shortcut_if_missing "Ulauncher" "ulauncher-toggle" "<Control>space"

	logMiniInfo "Adding ulauncher to Startup Applications"
	mkdir -p ~/.config/autostart/
	cp "./Assets/Configs/ulauncher/ulauncher.desktop" "$HOME/.config/autostart/ulauncher.desktop"

	logMiniInfo "Backing up settings and extensions of Ulauncher"
	if [[ -d "$HOME/.config/ulauncher/" ]]; then
		mkdir -p "$backup_dir/ulauncher/"
		mv "$HOME/.config/ulauncher/settings.json" "$backup_dir/ulauncher/"
		mv "$HOME/.local/share/ulauncher/extensions/" "$backup_dir/ulauncher/extensions"
	fi

	logMiniInfo "Customizing Ulauncher"
	gtk-launch ulauncher.desktop >/dev/null 2>&1
	sleep 2                                         # Wait till ulauncher setup it's defaults
	cp "./Assets/Configs/ulauncher/ulauncher.json" "$HOME/.config/ulauncher/settings.json"

	logMiniInfo "Adding extensions"
	clone_repo "https://github.com/Ulauncher/ulauncher-emoji.git" "$HOME/.local/share/ulauncher/extensions/com.github.ulauncher.ulauncher-emoji/" "Ulauncher-emoji"
	clone_repo "https://github.com/manahter/ulauncher-translate.git" "$HOME/.local/share/ulauncher/extensions/com.github.manahter.ulauncher-translate/" "Ulauncher-translate"
	clone_repo "https://github.com/iboyperson/ulauncher-system.git" "$HOME/.local/share/ulauncher/extensions/com.github.iboyperson.ulauncher-system/" "Ulauncher-system"
	clone_repo "https://github.com/DevKleber/ulauncher-open-link.git" "$HOME/.local/share/ulauncher/extensions/com.github.devkleber.ulauncher-open-link/" "Ulauncher-open-link"
	clone_repo "https://github.com/NastuzziSamy/ulauncher-google-search.git" "$HOME/.local/share/ulauncher/extensions/com.github.nastuzzisamy.ulauncher-google-search/" "Ulauncher-google-search"
}

install_Ark(){
	logScriptMiniSubHead "Ark - GUI for compress and decompress files"
	installPackages "ark"
}

install_Gparted(){
	logScriptMiniSubHead "Gparted - Manage partitions"
	installPackages "gparted"
}

install_Timeshift(){
	logScriptMiniSubHead "Timeshift - Backup tool"
	installPackages "timeshift"
}

install_LocalSend(){
	logScriptMiniSubHead "LocalSend - Share files between your devices"
	installFlatpakPackage "org.localsend.localsend_app"
}

install_Libre_office(){
	logScriptMiniSubHead "Libre Office - Office suite"
	installPackages "libreoffice"
}

install_Obsidian(){
	logScriptMiniSubHead "Obsidian - Used to create notes"
    installPackages "fuse3"
    installFlatpakPackage "it.mijorus.gearlever"

    GEAR="flatpak run it.mijorus.gearlever"

    # If Obsidian is installed, then exit
    if command -v obsidian >/dev/null 2>&1; then
        logAlreadyInstall "Obsidian"
        return 0
    fi

	# Get latest url
    OBS_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | 
  		jq -r ' 
    	.assets[] 
    	| select(.name | test("appimage";"i")) 
		| select(.name | test("arm64") | not)
    	| .browser_download_url' | 
  		head -n1)
    OBS_PATH="./Temp/Obsidian.AppImage"

	# Download
    mkdir -p "./Temp/"
    wget "$OBS_URL" -O "$OBS_PATH" &>/dev/null &
    INSTALL_PID=$!
    spinner "$INSTALL_PID" "Downloading Obsidian"
    wait "$INSTALL_PID"
    if [[ $? -eq 0 ]]; then
	  logPass "Downloaded Obsidian"
    else
	  logFail "Failed to download Obsidian"
      exit 1
    fi
    chmod +x "$OBS_PATH"

	# Add to Gear Leaver
    $GEAR --integrate "$OBS_PATH"
	#ToDo: add update url
	#FINAL_PATH=$($GEAR --list-installed |
    #            awk 'tolower($1)=="obsidian" {print $NF; exit}')
    #$GEAR --set-update-url "$FINAL_PATH" "gh-releases-zsync|obsidianmd|obsidian-releases|latest|Obsidian-*.AppImage.zsync"
}

install_AppFlowy(){
	logScriptMiniSubHead "AppFlowy - Used to organize tasks, collaborate on projects, and track progress"
	installFlatpakPackage "io.appflowy.AppFlowy"
}

install_Zoom(){
	logScriptMiniSubHead "Zoom - Video communications platform"
	installFlatpakPackage "us.zoom.Zoom"
}

install_Discord(){
	logScriptMiniSubHead "Discord - A free communication app"
	installPackages "discord"
}

install_Telegram(){
	logScriptMiniSubHead "Telegram - A free messagig app"
	installPackages "telegram-desktop"
}

install_VLC(){
	logScriptMiniSubHead "vlc - Powerfull video player"
	installPackages "vlc"

	# Changing the config file
	logMiniInfo "Changing VLC configurations"
	mkdir -p "$HOME/.config/vlc/"
	delete_file_if_exists "$HOME/.config/vlc/vlcrc"
	cp "./Assets/Configs/vlc/vlcrc" "$HOME/.config/vlc/"

	# Installing extensions
	logMiniInfo "Adding playlist shuffle extension"
	curl -Lfs https://addons.videolan.org/p/1154030/loadFiles \
	| jq -r '.files[] | select(.name=="shuffle.lua") | .url' \
	| perl -pe 's/%(\w\w)/chr hex $1/ge' \
	| xargs wget -q -P ./Temp
	mkdir -p "$HOME/.local/share/vlc/lua/extensions/"
	delete_file_if_exists "$HOME/.local/share/vlc/lua/extensions/shuffle.lua"
	mv "./Temp/shuffle.lua" "$HOME/.local/share/vlc/lua/extensions/"
}

install_Obs_Studio(){
	logScriptMiniSubHead "Obs Studio - Screen recoder and streamer"
	installPackages "obs-studio"
	installPackages "kmod-v4l2loopback"		# To use Virtual Camera
}

install_Kdenlive(){
	logScriptMiniSubHead "Kdenlive - Video Editor"
	installPackages "kdenlive"
}

install_Lutris(){
	logScriptMiniSubHead "Lutris - Manage Games"
	installPackages "lutris"
}

install_Wine(){
	logScriptMiniSubHead "Wine - Run windows application on linux"
	installPackages "Wine"
}
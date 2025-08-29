#!/bin/bash

# Variables -------------
#                       |
#                       |
#                       |
#                       V
script_path="$(pwd)"
backup_dir="$HOME/old_dotfiles$(date +"%Y-%m-%d_%H-%M-%S")"



# Show Messages ---------
#                       |
#                       |
#                       |
#                       V

logScriptHead(){
    echo -e "\e[33m🥸 -> $1\e[0m";
}

logScriptSubHead(){
    echo -e "";
    echo -e "\e[33m   👉 $1\e[0m";
}

logInfo(){
    echo -e "\e[0m     ℹ️ $1";
}

logScriptMiniSubHead(){
    echo -e "\e[33m     🫳 $1\e[0m";
}

logMiniInfo(){
    echo -e "\e[0m       ℹ️ $1";
}

logPass(){
    echo -e "\e[32m     ✅ $1\e[0m";
}

logFail(){
    echo -e "\e[31m     ❎ $1\e[0m";
}

logAlreadyInstall() {
    echo -e "\e[32m     ✅ $1 is already installed\e[0m";
}

logPassInstall() {
    echo -e "\e[32m     ✅ Successfully installed $1\e[0m";
}

logFailInstall() {
    echo -e "\e[31m     ❎ Failed to install $1\e[0m";
}

logHighlight(){
    echo -e "\e[43m$1\e[0m";
}

logData(){
    echo -e "\e[0m$1";
}

logDone(){
    echo -e "\e[32m☑️ Done \e[0m";
}

logWarning() {
    echo -e "";
    echo -e "\e[31mWarning !!!";
    echo -e "\e[33m$1 \e[0m";
}

logError() {
    echo -e "";
    echo -e "\e[41mError:\e[0m";
    echo -e "\e[33m☠️ -> $1 \e[0m";
}

logMessage() {
    echo -e "";
    echo -e "Message:";
    echo -e "\e[33m🥸 -> $1\e[0m";
}

br() {
    echo -e "";
}

br5(){
    echo -e "";
    echo -e "";
    echo -e "";
    echo -e "";
    echo -e "";
}

logSummary() {
    echo -e "";
    echo -e "\e[36m     === $1 Summary ===\e[0m";
}



# Utilities -------------
#                       |
#                       |
#                       |
#                       V

# =======> For speeding-up DNF
add_configs() {
  local file="$1"
  local config="$2"
  grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" > /dev/null
}


# =======> Installing packages if not installed
installPackages(){
  if [[ -z "$1" ]]; then
    logInfo "No packages are provided to install"
    return 0
  fi
  if rpm -q "$1" &>/dev/null; then
    logAlreadyInstall "$1";
  else
    if sudo dnf install -y "$1" &>/dev/null; then
      logPassInstall "$1"
    else
      logFailInstall "$1"
      exit 1;
    fi
  fi
}

addRepo(){
  if ! dnf copr list | grep -q "$1"; then
    sudo dnf copr enable -y $1
    if dnf copr list | grep -q "$1"; then
      logPass "COPR repo $1 enabled."
    else
      logFail "COPR repo $1 is not enabled."
    fi
  else
    logPass "COPR repo $1 already enabled."
  fi
}

installPipPackages() {
  if ! command -v pip3 &> /dev/null; then
    installPackages "python3-pip"
    if pip3 show "$1" &> /dev/null; then
      logPass "$1 pip packages is already installed" 
    else
      pip3 install --upgrade $1
      if pip3 show "$1" &> /dev/null; then
        logPass "$1 pip package installed." 
      else
        logFail "$1 pip package is not installed." 
      fi
    fi
  else
    if pip3 show "$1" &> /dev/null; then
      logPass "$1 pip packages is already installed" 
    else
      pip3 install --upgrade $1
      if pip3 show "$1" &> /dev/null; then
        logPass "$1 pip package installed." 
      else
        logFail "$1 pip package is not installed." 
      fi
    fi
  fi
}

# Ensure flatpak and flathub are installed
ensureFlatpak(){
  if ! command -v flatpak &>/dev/null; then
    if sudo dnf install -y flatpak &>/dev/null; then
      logPassInstall "flatpak"
    else
      logFailInstall "flatpak"
      exit 1
    fi
  fi

  # Check if flathub remote exists
  if ! flatpak remote-list | grep -q "^flathub"; then
    if flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &>/dev/null; then
      logPassInstall "flathub remote"
    else
      logFailInstall "flathub remote"
      exit 1
    fi
  fi
}

# Install Flatpak package
installFlatpakPackage(){
  ensureFlatpak
  if flatpak list --app | grep -q "$1"; then
    logAlreadyInstall "$1"
  else
    if flatpak install -y flathub "$1" &>/dev/null; then
      logPassInstall "$1"
    else
      logFailInstall "$1"
      exit 1
    fi
  fi
}

# DNF Group Install
installDnfGroup(){
  if dnf group info "$1" 2>/dev/null | grep -q "Installed"; then
    logAlreadyInstall "group: $1"
  else
    if sudo dnf group install -y "$1" &>/dev/null; then
      logPassInstall "group: $1"
    else
      logFailInstall "group: $1"
      exit 1
    fi
  fi
}


# =======> Run Commands and log 
runCmd() { #Cmd, description
  if eval "$1"; then
    logPass "$2"
  else
    logFail "$2"
    exit 1
  fi
}



# =======> Adding custom shortcuts
SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
SUBSCHEMA="$SCHEMA.custom-keybinding"
BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

# Load current custom keybinding paths into EXISTING[]
get_existing() {
  local cur
  cur="$(gsettings get "$SCHEMA" custom-keybindings 2>/dev/null || echo "[]")"
  cur="${cur#@as }"
  cur="${cur#[}"
  cur="${cur%]}"
  cur="${cur// /}"
  if [[ -z "$cur" ]]; then
    EXISTING=()
  else
    IFS=',' read -ra EXISTING <<< "$cur"
  fi
}

# Write EXISTING[] back to gsettings
set_existing() {
  local arr="["
  for e in "${EXISTING[@]:-}"; do arr+="$e, "; done
  arr="${arr%, }]"
  gsettings set "$SCHEMA" custom-keybindings "$arr"
}

# Find next free /customN/
get_next_index() {
  local idx=0 path found
  while :; do
    path="'$BASE/custom${idx}/'"
    found=0
    for e in "${EXISTING[@]:-}"; do
      [[ "$e" == "$path" ]] && { found=1; break; }
    done
    (( found == 0 )) && { echo "$idx"; return; }
    ((idx++))
  done
}

# Check if the exact (command + binding) pair already exists
shortcut_exists() {
  local cmd="$1" bind="$2"
  local e p ec eb
  for e in "${EXISTING[@]:-}"; do
    p="${e//\'/}"
    ec="$(gsettings get "$SUBSCHEMA:$p" command 2>/dev/null || echo "''")"
    eb="$(gsettings get "$SUBSCHEMA:$p" binding 2>/dev/null || echo "''")"
    ec="${ec#\'}"; ec="${ec%\'}"
    eb="${eb#\'}"; eb="${eb%\'}"
    if [[ "$ec" == "$cmd" && "$eb" == "$bind" ]]; then
      return 0
    fi
  done
  return 1
}

# Append a new shortcut only if not present
add_shortcut_if_missing() {
  local name="$1" cmd="$2" bind="$3"
  get_existing
  if shortcut_exists "$cmd" "$bind"; then
    logPass "✔ Already present: $bind → $name"
    return 0
  fi
  local idx; idx="$(get_next_index)"
  local p="$BASE/custom${idx}/"
  EXISTING+=("'$p'")
  set_existing
  gsettings set "$SUBSCHEMA:$p" name "$name"
  gsettings set "$SUBSCHEMA:$p" command "$cmd"
  gsettings set "$SUBSCHEMA:$p" binding "$bind"
  logPass "✔ Added: $bind → $name"
}


# =======> File Manipulation
delete_file_if_exists() {
    local file="$1"
    if [[ -e "$file" ]]; then
        rm -f "$file" && logPass "Deleted: $file" || logFail "Failed to delete: $file"
    fi
}

delete_folder_if_exists() {
    local folder="$1"
    if [[ -d "$folder" ]]; then
        rm -rf "$folder" && logPass "Deleted: $folder" || logFail "Failed to delete: $folder"
    fi
}

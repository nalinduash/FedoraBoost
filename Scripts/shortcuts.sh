#!/bin/bash

# Importing SH files
source ./Scripts/common.sh;

logInfo "Adding shortcuts";



# Add gnome's default shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']" 
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"



# Custom Shortcuts
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

# Shortcuts (only append if missing)
add_shortcut_if_missing "Ulauncher" "ulauncher-toggle" "<Control>space"
add_shortcut_if_missing "Ghostty"   "ghostty"          "<Control><Alt>t"
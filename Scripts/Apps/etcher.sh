#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

logScriptMiniSubHead "etcher"

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
spinner "$INSTALL_PID" "Clonning repo: [$name]"

wait "$INSTALL_PID"
if [[ $? -eq 0 ]]; then
  logPass "$APP_NAME is successfully downloaded"
else
  logFail "$APP_NAME is failed to download"
  return 1
fi

installPackages "$TMP_FILE"

rm -f "$TMP_FILE"


#!/bin/bash

# Variables -------------
#                       |
#                       |
#                       |
#                       V
script_path="$(pwd)"
backup_dir="$HOME/old_dotfiles"

# Show Messages ---------
#                       |
#                       |
#                       |
#                       V

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
    echo -e "\e[33m🥸 -> $1\e[0m";
}

logInfo() {
    echo -e "\e[0m$1 🥸";
}

br() {
    echo -e "";
}

logAlreadyInstall() {
    echo -e "\e[32m✓ $1 is already installed\e[0m";
}

logPassInstall() {
    echo -e "\e[32m✓ Successfully installed $1\e[0m";
}

logFailInstall() {
    echo -e "\e[31m✗ Failed to install $1\e[0m";
}

logSummary() {
    echo -e "";
    echo -e "\e[36m=== $1 Summary ===\e[0m";
}

logPass(){
    echo -e "\e[32m$1\e[0m";
}
logFail(){
    echo -e "\e[31m$1\e[0m";
}



# Utilities -------------
#                       |
#                       |
#                       |
#                       V

add_configs() {
  local file="$1"
  local config="$2"
  grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" > /dev/null
}

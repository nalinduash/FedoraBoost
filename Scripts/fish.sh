#!/bin/bash

# Source common.sh 
source ./Scripts/common.sh;

# Install oh-my-posh (with check)
if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
    logPassInstall "oh-my-posh"
else
    logAlreadyInstall "oh-my-posh"
fi

# Add oh-my-posh to PATH
if ! grep -qx '/usr/local/bin/fish' /etc/shells; then
    echo '/usr/local/bin/fish' | sudo tee -a /etc/shells
else
    logAlreadyInstall "Fish shell already in /etc/shells"
fi
if ! grep -qx '/usr/sbin/fish' /etc/shells; then
    echo '/usr/sbin/fish' | sudo tee -a /etc/shells
else
    logAlreadyInstall "Fish shell already in /etc/shells"
fi  

# Change default shell to Fish
logInfo "Changing default shell to Fish..."
if ! chsh -s "$(which fish)"; then
    logError "Failed to change default shell to Fish."
    exit 1
fi
logPass "Shell changed to Fish successfully."

# Backup and copy fastfetch config
if [ -d ~/.config/fastfetch ]; then
    logInfo "Backing up existing fastfetch config..."
    mkdir -p "$backup_dir/fastfetch"
    mv "$HOME/.config/fastfetch" "$backup_dir/fastfetch"
fi

logInfo "Copying fastfetch config..."
cp -r "./Assets/Configs/fastfetch" "$HOME/.config/"

# Backup only fish config if it exists
if [ -f $HOME/.config/fish/config.fish ]; then
    logInfo "Backing up existing fish config..."
    mkdir -p "$backup_dir/fish"
    mv "$HOME/.config/fish/config.fish" "$backup_dir/fish/config.fish"
fi

logInfo "Copying Fish config..."
mkdir -p $HOME/.config/fish
cp "./Assets/Configs/fish/config.fish" "$HOME/.config/fish/config.fish"

# Adding shortcuts for ghostty
add_shortcut_if_missing "Ghostty" "ghostty" "<Control><Alt>t"
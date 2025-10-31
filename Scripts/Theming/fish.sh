#!/bin/bash

# Source common.sh 
source ./Scripts/common.sh

# Install packages
logScriptMiniSubHead "Adding some packages"
addRepo "scottames/ghostty"                 # Add repository containing ghostty
installPackages "fastfetch"                 # Show system information
installPackages "ghostty"                   # Powerful terminal
installPackages "fish"                      # Fast shell interpreter 

# Add configs for ghostty
logScriptMiniSubHead "Adding configs for ghostty"
delete_file_if_exists "$HOME/.config/ghostty/config"
mkdir -p "$HOME/.config/ghostty"
cp "./Assets/Configs/ghostty/config" "$HOME/.config/ghostty/"

# Install oh-my-posh 
logScriptMiniSubHead "Installing Oh-My-Posh"
installPackages "oh-my-posh"

# Add Fish to PATH
logScriptMiniSubHead "Add oh-my-posh to PATH"
if ! grep -qx '/usr/local/bin/fish' /etc/shells; then
    echo '/usr/local/bin/fish' | sudo tee -a /etc/shells
else
    logPass "Fish shell already in /etc/shells"
fi
if ! grep -qx '/usr/sbin/fish' /etc/shells; then
    echo '/usr/sbin/fish' | sudo tee -a /etc/shells
else
    logPass "Fish shell already in /etc/shells"
fi  

# Change default shell to Fish
logScriptMiniSubHead "Changing default shell to Fish"
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" = "fish" ]; then
    logPass "Default shell is already fish 🐟. Skipping shell change."
else
    if ! chsh -s "$(which fish)"; then
        logError "Failed to change default shell to Fish."
        exit 1
    fi
    logPass "Shell changed to Fish successfully."
fi

# Backup and copy fastfetch config
if [ -d ~/.config/fastfetch ]; then
    logScriptMiniSubHead "Backing up existing fastfetch config"
    mkdir -p "$backup_dir/fastfetch"
    mv "$HOME/.config/fastfetch" "$backup_dir/fastfetch"
fi

logScriptMiniSubHead "Copying fastfetch config..."
cp -r "./Assets/Configs/fastfetch" "$HOME/.config/"

# Backup only fish config if it exists
if [ -f $HOME/.config/fish/config.fish ]; then
    logScriptMiniSubHead "Backing up existing fish config"
    mkdir -p "$backup_dir/fish"
    mv "$HOME/.config/fish/config.fish" "$backup_dir/fish/config.fish"
fi

logScriptMiniSubHead "Copying Fish config"
mkdir -p $HOME/.config/fish
cp "./Assets/Configs/fish/config.fish" "$HOME/.config/fish/config.fish"

logScriptMiniSubHead "Copying Oh-my-posh config"
mkdir -p $HOME/.config/oh-my-posh
cp "./Assets/Configs/oh-my-posh/atomic.omp.json" "$HOME/.config/oh-my-posh/atomic.omp.json"

# Adding shortcuts for ghostty
logScriptMiniSubHead "Adding ghostty shortcuts"
add_shortcut_if_missing "Ghostty" "ghostty" "<Control><Alt>t"
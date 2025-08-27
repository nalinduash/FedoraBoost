#!/bin/bash

# Source common.sh 
source ./Scripts/common.sh;

# Install packages
logScriptMiniSubHead "Adding some packages"
addRepo "scottames/ghostty"                 # Add repository containing ghostty
installPackages "fastfetch"                 # Show system information
installPackages "ghostty"                   # Powerful terminal
installPackages "fish"                      # Fast shell interpreter 

# Install oh-my-posh 
logScriptMiniSubHead "Installing Oh-My-Posh"
if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
    logPassInstall "oh-my-posh"
else
    logAlreadyInstall "oh-my-posh"
fi

# Add oh-my-posh to PATH
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

# Adding shortcuts for ghostty
logScriptMiniSubHead "Adding ghostty shortcuts"
add_shortcut_if_missing "Ghostty" "ghostty" "<Control><Alt>t"
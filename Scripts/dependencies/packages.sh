#!/bin/bash

# Importing SH files
source ./Scripts/common.sh


# Packages to install
packages=(
    "btop"                          # System Monitor
    "fastfetch"                     # Fast system information tool. Also used to customize the terminal 
    "ghostty"                       # Terminal
    "fish"                          # Friendly interactive shell. Used to interprit commands
    "wget"                          # Download files from the web
    "curl"                          # Transfer data from or to a server
    "git"                           # Version control system
    "python3-pip"                   # To install gnome-extension-cli to automate the installation of gnome extensions
    "gnome-extensions-app"          # Manage Gnome extensions
)


# Install packages one by one
success_count=0
failed_count=0
failed_packages=()

for package in "${packages[@]}"; do
    # Check if package is already installed
    if rpm -q "$package" &>/dev/null; then
        logAlreadyInstall "$package";
        ((success_count++))
        continue
    fi
    
    # Install the package
    if sudo dnf install -y "$package" &>/dev/null; then
        logPassInstall "$package";
        ((success_count++))
    else
        logFailInstall "$package"
        ((failed_count++))
        failed_packages+=("$package")
    fi
done



# Retry failed packages at the end
if [[ $failed_count -gt 0 ]]; then
    logWarning "I'll try again in 15 seconds 😐";
    sleep 15;

    logInfo "2.1 - Retrying to install failed packages";
    echo -e "";

    retry_success_count=0
    still_failed_packages=()
    
    for package in "${failed_packages[@]}"; do
        if sudo dnf install -y "$package" &>/dev/null; then
            logPassInstall "$package"
            ((retry_success_count++))
            ((success_count++))
            ((failed_count--))
        else
            logFailInstall "$package"
            still_failed_packages+=("$package")
        fi
    done
    
    # Update failed packages list
    failed_packages=("${still_failed_packages[@]}")
fi

# Summary
logSummary "Installation";
logPass "Successfully installed: $success_count packages";

if [[ $failed_count -gt 0 ]]; then
    logFail "Failed to install: $failed_count packages"
    logFail "Failed packages: ${failed_packages[*]}"
else
    logPass "All packages installed successfully! 🎉";
fi

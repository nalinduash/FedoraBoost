#!/bin/bash

# Importing SH files
source ./Scripts/common.sh


# Add free and non-free repositories
if ! dnf repolist --enabled | grep -q "^rpmfusion-free"; then
    if sudo dnf install -y -q https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm &>/dev/null; then
        logPassInstall "RPM Fusion Free repository";
    else
        logFailInstall "RPM Fusion Free repository";
    fi
else
    logAlreadyInstall "RPM Fusion Free repository";
fi

if ! dnf repolist --enabled | grep -q "^rpmfusion-nonfree"; then
    if sudo dnf install -y -q https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm &>/dev/null; then
        logPassInstall "RPM Fusion Non-Free repository";
    else
        logFailInstall "RPM Fusion Non-Free repository";
    fi
else
    logAlreadyInstall "RPM Fusion Non-Free repository";
fi


# Add custom repos for such as ghostty
if ! dnf copr list | grep -q "scottames/ghostty"; then
    sudo dnf copr enable -y scottames/ghostty
    logPassInstall "COPR repo scottames/ghostty enabled."
else
    logAlreadyInstall "COPR repo scottames/ghostty already enabled."
fi

# Summary
logSummary "Repo Installation";
logPass "All Repos Successfully installed";

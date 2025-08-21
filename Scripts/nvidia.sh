#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

# Detect NVIDIA GPU
GPU_MODEL=$(lspci | grep -i nvidia | awk -F ': ' '{print $2}')

# Determine driver version
DRIVER=""
CUDA_PACKAGE=""

if [[ $GPU_MODEL =~ "GeForce" ]]; then
    if [[ $GPU_MODEL =~ "GTX 6" ]] || [[ $GPU_MODEL =~ "GT 6" ]] || \
       [[ $GPU_MODEL =~ "GTX 7" ]] || [[ $GPU_MODEL =~ "GT 7" ]]; then
        DRIVER="470xx"
        CUDA_PACKAGE="xorg-x11-drv-nvidia-470xx-cuda"
    elif [[ $GPU_MODEL =~ "GTX 4" ]] || [[ $GPU_MODEL =~ "GT 4" ]] || \
         [[ $GPU_MODEL =~ "GTX 5" ]] || [[ $GPU_MODEL =~ "GT 5" ]]; then
        DRIVER="390xx"
        CUDA_PACKAGE="xorg-x11-drv-nvidia-390xx-cuda"
    elif [[ $GPU_MODEL =~ "GeForce 8" ]] || [[ $GPU_MODEL =~ "GeForce 9" ]] || \
         [[ $GPU_MODEL =~ "GeForce 2" ]] || [[ $GPU_MODEL =~ "GeForce 3" ]] || \
         [[ $GPU_MODEL =~ "GeForce 200" ]] || [[ $GPU_MODEL =~ "GeForce 300" ]]; then
        DRIVER="340xx"
        CUDA_PACKAGE="xorg-x11-drv-nvidia-340xx-cuda"
    else
        DRIVER="latest"
        CUDA_PACKAGE="xorg-x11-drv-nvidia-cuda"
    fi
else
    logPass "No Nvdia card found. Skipping"
    return 0
fi

echo "Detected GPU: $GPU_MODEL"
echo "Installing NVIDIA driver version: $DRIVER"

installPackages "kernel-headers"
installPackages "kernel-devel"

# Install the appropriate NVIDIA driver
case $DRIVER in
    "470xx")
        installPackages "akmod-nvidia-470xx"
        installPackages "xorg-x11-drv-nvidia-470xx"
        installPackages "$CUDA_PACKAGE"
        ;;
    "390xx")
        installPackages "akmod-nvidia-390xx"
        installPackages "xorg-x11-drv-nvidia-390xx"
        installPackages "$CUDA_PACKAGE"
        ;;
    "340xx")
        # For newer Fedora, enable longterm kernel support
        addRepo "kwizart/kernel-longterm-6.1"
        installPackages "akmods"
        installPackages "gcc"
        installPackages "kernel-longterm"
        installPackages "kernel-longterm-devel"
        installPackages "akmod-nvidia-340xx"
        installPackages "xorg-x11-drv-nvidia-340xx"
        installPackages "$CUDA_PACKAGE"
        ;;
    "latest")
        installPackages "akmod-nvidia"
        installPackages "xorg-x11-drv-nvidia"
        installPackages "$CUDA_PACKAGE"
        ;;
esac

# Mark driver to prevent accidental removal
sudo dnf mark user akmod-nvidia*

# Blacklist nouveau to avoid conflicts
sudo touch "/etc/modprobe.d/blacklist-nouveau.conf"
add_configs "/etc/modprobe.d/blacklist-nouveau.conf" "blacklist nouveau" 
sudo dracut --force
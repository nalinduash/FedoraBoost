#!/bin/bash

# Source common.sh 
source ./Scripts/common.sh;

# Install packages
installPackages "gnome-extensions-app"          # Manage Gnome extensions
installPackages "gnome-tweaks"                  # Change Gnome appearance
installPipPackages "gnome-extensions-cli"       # To install Gnome extensions

# Install Gnome extensions if they are not installed
install_extension() {
  if gext list | grep -q "$1"; then
    logInfo "Extension already installed: $1"
    gext enable "$1"
  else
    gext install "$1"
    gext enable "$1"
  fi
}

# Turn off some default Fedora extensions
gnome-extensions disable launch-new-instance@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable window-list@gnome-shell-extensions.gcampax.github.com

# Turn on some default Fedora extensions
gnome-extensions enable apps-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable background-logo@fedorahosted.org
gnome-extensions enable places-menu@gnome-shell-extensions.gcampax.github.com

# Install new extensions
install_extension "appindicatorsupport@rgcjonas.gmail.com"
install_extension "blur-my-shell@aunetx"
install_extension "clipboard-indicator@tudmotu.com"
install_extension "compiz-alike-magic-lamp-effect@hermes83.github.com"
install_extension "compiz-windows-effect@hermes83.github.com"
install_extension "dash2dock-lite@icedman.github.com"
install_extension "desktop-cube@schneegans.github.com"
install_extension "mediacontrols@cliffniff.github.com"
install_extension "tiling-assistant@leleat-on-github"
install_extension "tophat@fflewddur.github.io"
install_extension "user-theme@gnome-shell-extensions.gcampax.github.com"
install_extension "azwallpaper@azwallpaper.gitlab.com"

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com/schemas/org.gnome.shell.extensions.appindicator.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/compiz-alike-magic-lamp-effect@hermes83.github.com/schemas/org.gnome.shell.extensions.com.github.hermes83.compiz-alike-magic-lamp-effect.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/compiz-windows-effect@hermes83.github.com/schemas/org.gnome.shell.extensions.com.github.hermes83.compiz-windows-effect.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/dash2dock-lite@icedman.github.com/schemas/org.gnome.shell.extensions.dash2dock-lite.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/desktop-cube@schneegans.github.com/schemas/org.gnome.shell.extensions.desktop-cube.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/mediacontrols@cliffniff.github.com/schemas/org.gnome.shell.extensions.mediacontrols.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tiling-assistant@leleat-on-github/schemas/org.gnome.shell.extensions.tiling-assistant.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/schemas/org.gnome.shell.extensions.user-theme.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/azwallpaper@azwallpaper.gitlab.com/schemas/org.gnome.shell.extensions.azwallpaper.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null


# Changing settings of AppIndicator and KStatusNotifierItem Support
gsettings set org.gnome.shell.extensions.appindicator tray-pos "center"

# Changing settings of Dash2Dock Animated
gsettings set org.gnome.shell.extensions.dash2dock-lite open-app-animation true
gsettings set org.gnome.shell.extensions.dash2dock-lite autohide-dash true
gsettings set org.gnome.shell.extensions.dash2dock-lite shrink-icons true
gsettings set org.gnome.shell.extensions.dash2dock-lite edge-distance 0.6
gsettings set org.gnome.shell.extensions.dash2dock-lite border-radius 2
gsettings set org.gnome.shell.extensions.dash2dock-lite running-indicator-style 1  
gsettings set org.gnome.shell.extensions.dash2dock-lite trash-icon true

# Changing settings of TopHat
gsettings set org.gnome.shell.extensions.tophat cpu-display 'numeric'
gsettings set org.gnome.shell.extensions.tophat mem-abs-units true
gsettings set org.gnome.shell.extensions.tophat mem-display 'numeric'
gsettings set org.gnome.shell.extensions.tophat meter-fg-color 'rgb(113,146,148)'

# Changing settings of Background logo
gsettings set org.fedorahosted.background-logo-extension logo-position 'bottom-right'
gsettings set org.fedorahosted.background-logo-extension logo-size 8
gsettings set org.fedorahosted.background-logo-extension logo-border 25
gsettings set org.fedorahosted.background-logo-extension logo-always-visible true

# Changing settings of Wallpaper Slideshow
WALL_LOCATION="$HOME/.local/share/backgrounds/nalindu-dotfiles"
mkdir -p "$WALL_LOCATION"
gsettings set org.gnome.shell.extensions.azwallpaper slideshow-directory "$WALL_LOCATION"
gsettings set org.gnome.shell.extensions.azwallpaper slideshow-slide-duration "(24, 0, 0)"
gsettings set org.gnome.shell.extensions.azwallpaper slideshow-use-absolute-time-for-duration true



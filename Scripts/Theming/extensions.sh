#!/bin/bash

# Source common.sh 
source ./Scripts/common.sh;

# Install packages
logScriptMiniSubHead "Installing some packages"
installPackages "gnome-extensions-app"          # Manage Gnome extensions
installPackages "gnome-tweaks"                  # Change Gnome appearance
installPipPackages "gnome-extensions-cli"       # To install Gnome extensions

# Back up extension names
logScriptMiniSubHead "Backing up extension names"
uuids=$(gext list 2>/dev/null | grep -v "/system" | grep -Eo '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' || true)
mkdir -p $backup_dir
if [ -z "$uuids" ]; then
  logPass "No user extensions found."
else
  echo "$uuids" > "$backup_dir/gnome-extensions-list.txt"
  logPass "Extension list saved to $backup_dir/gnome-extensions-list.txt"
fi

# Back up extension configs
logScriptMiniSubHead "Backing up extension configs"
dconf dump /org/gnome/shell/extensions/ > "$backup_dir/gnome-extensions-settings.dconf"

# Delete existing extensions
logScriptMiniSubHead "Deleting existing extensions"
delete_folder_if_exists "$HOME/.local/share/gnome-shell/extensions/"
runCmd "dconf reset -f /org/gnome/shell/extensions/" "Resetting configurations of Gnome extensions"

# Install Gnome extensions if they are not installed
installed=$(gext list)
install_extension() {
  if echo "$installed" | grep -q "$1"; then
    logAlreadyInstall "$1 Extension"
  else
    gext install "$1" &>/dev/null &
    INSTALL_PID=$!
	spinner "$INSTALL_PID" "Installing [$1]"
    wait "$INSTALL_PID"
    wait "$INSTALL_PID"
    if [[ $? -eq 0 ]]; then
      gext enable "$1" &>/dev/null
      logPassInstall "$1"
    else
      logFailInstall "$1"
      exit 1
    fi
  fi
}

# Turn off some default Fedora extensions
logScriptMiniSubHead "Turning off some default Fedora extensions"
gnome-extensions disable launch-new-instance@gnome-shell-extensions.gcampax.github.com
gnome-extensions disable window-list@gnome-shell-extensions.gcampax.github.com

# Turn on some default Fedora extensions
logScriptMiniSubHead "Turning on some default Fedora extensions"
gnome-extensions enable apps-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable background-logo@fedorahosted.org
gnome-extensions enable places-menu@gnome-shell-extensions.gcampax.github.com

# Install new extensions
logScriptMiniSubHead "Installing new extensions if not installed"
br
install_extension "appindicatorsupport@rgcjonas.gmail.com"
install_extension "blur-my-shell@aunetx"
install_extension "clipboard-indicator@tudmotu.com"
install_extension "compiz-alike-magic-lamp-effect@hermes83.github.com"
install_extension "compiz-windows-effect@hermes83.github.com"
install_extension "dash-to-panel@jderose9.github.com"
install_extension "desktop-cube@schneegans.github.com"
install_extension "mediacontrols@cliffniff.github.com"
install_extension "tiling-assistant@leleat-on-github"
install_extension "tophat@fflewddur.github.io"
install_extension "user-theme@gnome-shell-extensions.gcampax.github.com"
install_extension "azwallpaper@azwallpaper.gitlab.com"
install_extension "caffeine@patapon.info"

# Compile gsettings schemas in order to be able to set them
logScriptMiniSubHead "Compiling gsettings schemas in order to be able to set them"
sudo cp ~/.local/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com/schemas/org.gnome.shell.extensions.appindicator.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/compiz-alike-magic-lamp-effect@hermes83.github.com/schemas/org.gnome.shell.extensions.com.github.hermes83.compiz-alike-magic-lamp-effect.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/compiz-windows-effect@hermes83.github.com/schemas/org.gnome.shell.extensions.com.github.hermes83.compiz-windows-effect.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/org.gnome.shell.extensions.dash-to-panel.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/desktop-cube@schneegans.github.com/schemas/org.gnome.shell.extensions.desktop-cube.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/mediacontrols@cliffniff.github.com/schemas/org.gnome.shell.extensions.mediacontrols.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tiling-assistant@leleat-on-github/schemas/org.gnome.shell.extensions.tiling-assistant.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/schemas/org.gnome.shell.extensions.user-theme.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/azwallpaper@azwallpaper.gitlab.com/schemas/org.gnome.shell.extensions.azwallpaper.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/caffeine@patapon.info/schemas/org.gnome.shell.extensions.caffeine.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null


# Changing settings of AppIndicator and KStatusNotifierItem Support
logMiniInfo "Customizing AppIndicator and KStatusNotifierItem Support"
gsettings set org.gnome.shell.extensions.appindicator tray-pos "center"

# Changing settings of Dash-to-Panel
logMiniInfo "Customizing Dash-to-Panel"
gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover true
gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-zoom "{'SIMPLE': 1.5, 'RIPPLE': 1.25, 'PLANK': 2.0}"
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-margin 4
gsettings set org.gnome.shell.extensions.dash-to-panel dot-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-panel click-action 'TOGGLE-SPREAD'
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-unfocused 'DOTS'
gsettings set org.gnome.shell.extensions.dash-to-panel global-border-radius 5
gsettings set org.gnome.shell.extensions.dash-to-panel hide-overview-on-startup true
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide true
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-animation-time 100
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-close-delay 100
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-enable-start-delay 500
gsettings set org.gnome.shell.extensions.dash-to-panel intellihide-hide-from-windows true
gsettings set org.gnome.shell.extensions.dash-to-panel panel-anchors '{"CMN-0x00000000":"MIDDLE"}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-element-positions '{"CMN-0x00000000":[
                                                                                                  {"element":"taskbar","visible":true,"position":"stackedTL"},
                                                                                                  {"element":"dateMenu","visible":true,"position":"stackedBR"},
                                                                                                  {"element":"showAppsButton","visible":true,"position":"stackedBR"},
                                                                                                  {"element":"activitiesButton","visible":false,"position":"stackedTL"},
                                                                                                  {"element":"leftBox","visible":false,"position":"stackedTL"},
                                                                                                  {"element":"centerBox","visible":false,"position":"stackedBR"},
                                                                                                  {"element":"rightBox","visible":false,"position":"stackedBR"},
                                                                                                  {"element":"systemMenu","visible":false,"position":"stackedBR"},
                                                                                                  {"element":"desktopButton","visible":false,"position":"stackedBR"}
                                                                                                ]
                                                                                }'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-lengths '{"CMN-0x00000000":70}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-positions '{}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-sizes '{"CMN-0x00000000":60}'
gsettings set org.gnome.shell.extensions.dash-to-panel prefs-opened false
gsettings set org.gnome.shell.extensions.dash-to-panel preview-use-custom-opacity true
gsettings set org.gnome.shell.extensions.dash-to-panel stockgs-keep-top-panel true
gsettings set org.gnome.shell.extensions.dash-to-panel trans-gradient-top-color '#000000'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-gradient-top-opacity 0.0
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.5
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-custom-opacity true
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-dynamic-opacity true
gsettings set org.gnome.shell.extensions.dash-to-panel window-preview-padding 15
gsettings set org.gnome.shell.extensions.dash-to-panel window-preview-size 180


# Changing settings of Blur-my-shell
logMiniInfo "Customizing Blur-my-shell"
gsettings set org.gnome.shell.extensions.blur-my-shell.panel pipeline 'pipeline_default_rounded'

# Changing settings of TopHat
logMiniInfo "Customizing TopHat"
gsettings set org.gnome.shell.extensions.tophat cpu-display 'numeric'
gsettings set org.gnome.shell.extensions.tophat mem-abs-units true
gsettings set org.gnome.shell.extensions.tophat mem-display 'numeric'
gsettings set org.gnome.shell.extensions.tophat meter-fg-color 'rgb(113,146,148)'
gsettings set org.gnome.shell.extensions.tophat position-in-panel 'center'

# Changing settings of Background logo
logMiniInfo "Customizing Background logo"
gsettings set org.fedorahosted.background-logo-extension logo-position 'bottom-right'
gsettings set org.fedorahosted.background-logo-extension logo-size 8
gsettings set org.fedorahosted.background-logo-extension logo-border 25
gsettings set org.fedorahosted.background-logo-extension logo-always-visible true

# Changing settings of Wallpaper Slideshow
logMiniInfo "Customizing Wallpaper Slideshow"
WALL_LOCATION="$HOME/.local/share/backgrounds/nalindu-dotfiles"
mkdir -p "$WALL_LOCATION"
gsettings set org.gnome.shell.extensions.azwallpaper slideshow-directory "$WALL_LOCATION"
gsettings set org.gnome.shell.extensions.azwallpaper slideshow-slide-duration "(24, 0, 0)"
gsettings set org.gnome.shell.extensions.azwallpaper slideshow-use-absolute-time-for-duration true

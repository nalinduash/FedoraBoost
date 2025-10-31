# Set Oh-my-posh path
set -gx PATH $PATH $HOME/.local/bin

if status is-interactive
    # Oh My Posh init 
    oh-my-posh init fish --config '~/.config/oh-my-posh/atomic.omp.json' | source

    set supports_images 0

    # Kitty check
    if set -q KITTY_WINDOW_ID
        set supports_images 1
    # Ghostty check
    else if test "$TERM" = "xterm-ghostty"
        set supports_images 1
    else
        set supports_images 0
    end

    if test $supports_images -eq 1
        # Fastfetch random image configs
        set PIC (math (random) % 4)
        switch $PIC
            case 0
                fastfetch -c ~/.config/fastfetch/Pic-1.jsonc
            case 1
                fastfetch -c ~/.config/fastfetch/Pic-2.jsonc
            case 2
                fastfetch -c ~/.config/fastfetch/Pic-3.jsonc
            case 3
                fastfetch -c ~/.config/fastfetch/Pic-4.jsonc
        end
    else
        # Fallback: Fedora ASCII logo
        fastfetch
    end

    # Disable the default greeting
    set -g fish_greeting
end


# Alias (packages)
alias update='sudo dnf update && gext update'
alias updatep='sudo dnf update'
alias updateg='gext update'
alias upgrade='sudo dnf upgrade'
alias add='sudo dnf install $1'
alias delete='sudo dnf remove $1'
alias search='dnf search $1'
alias uu="sudo dnf update && sudo dnf upgrade"


# Alias (system)
alias bye='systemctl poweroff'


# Alias (common)
alias c='clear'  
alias h='history' 


# Alias (other)
alias ff='fastfetch'
alias nf='fastfetch'


# Alias (extra)
alias al="echo ------------Your curent aliases are:------------ ;alias" 


# Flatpack Applications
alias gearlever='flatpak run it.mijorus.gearlever'

alias missioncenter='flatpak run io.missioncenter.MissionCenter'
alias taskmanager='flatpak run io.missioncenter.MissionCenter'
alias mc='flatpak run io.missioncenter.MissionCenter'
alias tm='flatpak run io.missioncenter.MissionCenter'

alias localsend='flatpak run org.localsend.localsend_app'

alias appflowy='flatpak run io.appflowy.AppFlowy'
alias notion='flatpak run io.appflowy.AppFlowy'

alias zoom='flatpak run us.zoom.Zoom'
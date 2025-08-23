# Set Oh-my-posh path
set -gx PATH $PATH $HOME/.local/bin

if status is-interactive
    # Oh My Posh init 
    oh-my-posh init fish --config '~/.cache/oh-my-posh/themes/atomic.omp.json' | source

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

# Set Oh-my-posh path
set -gx PATH $PATH $HOME/.local/bin

if status is-interactive
    # Oh My Posh init 
    oh-my-posh init fish --config '~/.cache/oh-my-posh/themes/atomic.omp.json' | source
     
    # Fastfetch random display
    set PIC (math (random) % 4)

    switch $PIC
        case 0
            fastfetch -c ~/.config/fastfetch/God-1.jsonc
        case 1
            fastfetch -c ~/.config/fastfetch/God-2.jsonc
        case 2
            fastfetch -c ~/.config/fastfetch/God-3.jsonc
        case 3
            fastfetch -c ~/.config/fastfetch/God-4.jsonc
    end
    
    
    
    # Disable the default greeting
    set -g fish_greeting
end




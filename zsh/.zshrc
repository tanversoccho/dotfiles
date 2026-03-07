# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnosterzak"

plugins=( 
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

#######################################
# Prompt (Starship)
#######################################

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias ll='ls -lah'
alias lla='ls -la'
alias lt='ls --tree'

alias ..='cd ..'
alias ...='cd ../..'

alias c='clear'
alias grep='grep --color=auto'
#######################################
# Zoxide (smart cd)
#######################################

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

#######################################
# fzf
#######################################

if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi

#######################################
# Yazi
#######################################

y() {
    local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
    command yazi "$@" --cwd-file="$tmp"
    cwd="$(cat "$tmp")"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd "$cwd"
    rm -f "$tmp"
}
#######################################
# Editor
#######################################

export EDITOR=nvim
export VISUAL=nvim

#######################################
# Locale
#######################################

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

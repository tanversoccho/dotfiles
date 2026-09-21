# ─────────────────────────────────────────────
#  Zsh RC — thin loader
# ─────────────────────────────────────────────

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load shared dotfiles config BEFORE omz (so starship/zoxide init run first)
export DOTFILES_SHELL_DIR="$HOME/dotfiles/shell/shell"
source "$DOTFILES_SHELL_DIR/rc.sh" zsh


# Zsh-specific config below

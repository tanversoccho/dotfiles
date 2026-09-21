# ─────────────────────────────────────────────
#  Bash RC — thin loader
# ─────────────────────────────────────────────

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Load shared dotfiles config
export DOTFILES_SHELL_DIR="$HOME/dotfiles/shell/shell"
source "$DOTFILES_SHELL_DIR/rc.sh" bash

# Bash-specific config below
# (history, completion, etc.)

# Shared shell configuration loader
# Usage: source this from bashrc / zshrc

SHELL_RC_DIR="${DOTFILES_SHELL_DIR:-$HOME/dotfiles/shell/shell}"

[ -f "$SHELL_RC_DIR/env.sh" ]       && source "$SHELL_RC_DIR/env.sh"
[ -f "$SHELL_RC_DIR/aliases.sh" ]   && source "$SHELL_RC_DIR/aliases.sh"
[ -f "$SHELL_RC_DIR/functions.sh" ] && source "$SHELL_RC_DIR/functions.sh"
[ -f "$SHELL_RC_DIR/tools.sh" ]     && source "$SHELL_RC_DIR/tools.sh" "$1"

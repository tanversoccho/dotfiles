# Detect shell: pass "bash" or "zsh" as $1, else auto-detect
_shell_name="${1:-$(basename "${SHELL:-bash}")}"

# ─── Starship prompt ─────────────────────────
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init "$_shell_name")"
fi

# ─── Zoxide (smart cd) ───────────────────────
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init "$_shell_name")"
fi

# ─── fzf ─────────────────────────────────────
if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi

unset _shell_name

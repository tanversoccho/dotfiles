# Yazi wrapper: cd into the directory you exited from
y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    command yazi "$@" --cwd-file="$tmp"
    cwd="$(cat "$tmp")"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd "$cwd"
    rm -f "$tmp"
}

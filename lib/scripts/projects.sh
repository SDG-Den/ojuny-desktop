#!/usr/bin/env bash

INPUT="$1"

SHELL="/run/current-system/sw/bin/zsh"

DIR="$HOME/repos"

REPOS=$(find "$(realpath "$DIR")" -maxdepth 5 -name ".git" -type d -exec dirname {} \; | xargs -I {} readlink -f {})

if [ "$INPUT" != "" ]; then
    SELECTED="$(echo "$REPOS" | grep -E "$INPUT" | head -n 1)"
else
  SELECTED=$(echo "$REPOS" | fzf --layout=reverse --preview="clear && eza -al --color=always --group-directories-first --icons=always {} && echo "-----------------------------------------------------" && cat {}/README.md ")
fi

echo "$SELECTED"

if [ -f "$SELECTED/meson.build" ]; then
    DB_DIR="$HOME/.cache/clangd/$(basename "$SELECTED")"
    CMD="cd $SELECTED && nix develop -c zsh -c 'mkdir -p \"$DB_DIR\" && meson setup \"$DB_DIR\" \"$SELECTED\" >/dev/null 2>&1 || true; codium -n \"$SELECTED\"'"
elif cd $SELECTED && nix develop -c true; then
    CMD="cd $SELECTED && nix develop -c zsh -c 'codium -n $SELECTED'"
else
    CMD="codium -n $SELECTED"
fi

mmsg dispatch spawn_shell,"$CMD"

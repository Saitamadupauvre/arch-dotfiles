#!/usr/bin/env bash
# Theme picker (SUPER+SHIFT+T): lists themes in tofi, switches to the chosen one.
# Uses tofi's configV, which every theme ships, so it works whatever theme is active.
set -euo pipefail

THEMES_DIR="/home/alban/dotfiles/themes"
CURRENT="$(cat "$HOME/.config/hypr/current-theme" 2>/dev/null || echo calm-blue)"

choice=$(ls "$THEMES_DIR" | grep -v '^\.' \
    | sed "s/^$CURRENT\$/$CURRENT  (current)/" \
    | tofi -c ~/.config/tofi/configV --prompt-text " theme: " \
    | sed 's/  (current)$//') || exit 0

[[ -z "$choice" || "$choice" == "$CURRENT" ]] && exit 0

if out=$(~/.config/hypr/theme-switch.sh "$choice" 2>&1); then
    notify-send "Theme" "Switched to $choice"
else
    notify-send -u critical "Theme switch failed" "$out"
fi

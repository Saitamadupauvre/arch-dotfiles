#!/usr/bin/env bash
# Usage: theme-switch.sh <theme-name>
set -euo pipefail

THEME="$1"
THEMES_DIR="/home/alban/dotfiles/themes"

if [[ -z "$THEME" ]]; then
    echo "Usage: $0 <theme-name>"
    echo "Available themes: $(ls "$THEMES_DIR" | grep -v '^\.')"
    exit 1
fi

THEME_DIR="$THEMES_DIR/$THEME"

if [[ ! -d "$THEME_DIR" ]]; then
    echo "Theme '$THEME' not found in $THEMES_DIR"
    echo "Available: $(ls "$THEMES_DIR" | grep -v '^\.')"
    exit 1
fi

# Unstow all themes, stow new one
for dir in "$THEMES_DIR"/*/; do
    name=$(basename "$dir")
    stow --dir="$THEMES_DIR" --target="$HOME" -D "$name" 2>/dev/null || true
done

stow --dir="$THEMES_DIR" --target="$HOME" --no-folding "$THEME"

# Apply wallpaper from new theme
THEME_CONF="$THEME_DIR/.config/hypr/theme.conf"
WALLPAPER=$(grep '^\$wallpaper' "$THEME_CONF" | sed 's/.*= *//' | sed "s|~|$HOME|")
if [[ -f "$WALLPAPER" ]]; then
    swww img "$WALLPAPER" --transition-fps 255 --transition-type outer --transition-duration 0.8
else
    echo "Warning: wallpaper not found: $WALLPAPER"
fi

hyprctl reload
echo "Switched to theme: $THEME"

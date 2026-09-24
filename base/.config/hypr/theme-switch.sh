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

# Regenerate config files from palette.conf, if this theme uses the template system
if [[ -x "$THEME_DIR/generate.sh" ]]; then
    "$THEME_DIR/generate.sh"
fi

# Unstow all themes (base is a separate stow dir, never touched here), stow new one
for dir in "$THEMES_DIR"/*/; do
    name=$(basename "$dir")
    stow --dir="$THEMES_DIR" --target="$HOME" -D "$name" 2>/dev/null || true
done

stow --dir="$THEMES_DIR" --target="$HOME" --no-folding "$THEME"

# AGS bar can't relative-import a scss file that lives in a different stow
# tree than app.ts (esbuild resolves against the real path, not the symlink),
# so precompile the theme's style.scss into base's physical directory.
if [[ -f "$THEME_DIR/.config/ags/style.scss" ]] && command -v sass >/dev/null; then
    sass "$THEME_DIR/.config/ags/style.scss" \
        "/home/alban/dotfiles/base/.config/ags/style.compiled.css"
fi

# Apply today's rotating wallpaper if this theme ships one; otherwise fall back
# to the theme's static wallpaper.
if [[ -x "$HOME/.config/hypr/wallpaper-daily.sh" ]]; then
    "$HOME/.config/hypr/wallpaper-daily.sh"
else
    THEME_LUA="$THEME_DIR/.config/hypr/theme.lua"
    WALLPAPER=$(grep -E '^\s*wallpaper\s*=' "$THEME_LUA" | sed -E 's/.*"(.*)".*/\1/' | sed "s|~|$HOME|")
    if [[ -f "$WALLPAPER" ]]; then
        awww img "$WALLPAPER" --transition-fps 255 --transition-type outer --transition-duration 0.8
    else
        echo "Warning: wallpaper not found: $WALLPAPER"
    fi
fi

pkill -f "ags run" || true
ags run ~/.config/ags >/dev/null 2>&1 & disown

hyprctl reload
echo "Switched to theme: $THEME"

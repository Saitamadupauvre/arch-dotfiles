#!/usr/bin/env bash
# Usage: theme-switch.sh <theme-name>     (no argument: list themes)
set -euo pipefail

THEMES_DIR="/home/alban/dotfiles/themes"
STATE="$HOME/.config/hypr/current-theme"
THEME="${1:-}"

available() { ls "$THEMES_DIR" | grep -v '^\.' | tr '\n' ' '; }

if [[ -z "$THEME" ]]; then
    echo "Usage: $0 <theme-name>"
    echo "Current:   $(cat "$STATE" 2>/dev/null || echo calm-blue)"
    echo "Available: $(available)"
    exit 1
fi

THEME_DIR="$THEMES_DIR/$THEME"
if [[ ! -d "$THEME_DIR" ]]; then
    echo "Theme '$THEME' not found. Available: $(available)"
    exit 1
fi

# Read a field of a theme's shell.lua (`shell` global). Lists are printed one per line.
shell_field() {
    lua -e "dofile('$1/.config/hypr/shell.lua')
            local v = shell['$2']
            if type(v) == 'table' then for _, c in ipairs(v) do print(c) end
            elseif v then print(v) end"
}

OLD="$(cat "$STATE" 2>/dev/null || echo calm-blue)"

# 0. Dry-run: refuse to switch if the new theme would collide with real files in $HOME
#    (checked before anything is unstowed, so a conflict never leaves you theme-less).
#    Conflicts with the currently stowed theme's own links are fine — those get unstowed.
conflicts=$(stow -n --dir="$THEMES_DIR" --target="$HOME" --no-folding "$THEME" 2>&1 \
    | grep 'neither a link nor a directory' || true)
if [[ -n "$conflicts" ]]; then
    echo "Cannot switch to '$THEME' — real files in the way (move or delete them first):"
    echo "$conflicts" | sed -E 's/.*existing target ([^ ]+).*/  ~\/\1/'
    exit 1
fi

# 1. Stop the old theme's shell (bar, notifications, wallpaper daemon...)
if [[ -f "$THEMES_DIR/$OLD/.config/hypr/shell.lua" ]]; then
    sh -c "$(shell_field "$THEMES_DIR/$OLD" stop)" || true
fi

# 2. Regenerate config files from palette.conf, if this theme uses the template system
if [[ -x "$THEME_DIR/generate.sh" ]]; then
    "$THEME_DIR/generate.sh"
fi

# 3. Unstow all themes (base is a separate stow dir, never touched here), stow new one
for dir in "$THEMES_DIR"/*/; do
    stow --dir="$THEMES_DIR" --target="$HOME" -D "$(basename "$dir")" 2>/dev/null || true
done
stow --dir="$THEMES_DIR" --target="$HOME" --no-folding "$THEME"
echo "$THEME" > "$STATE"

# 4. Reload Hyprland (re-reads current-theme → new shell.lua/theme.lua/behavior.lua)
hyprctl reload >/dev/null

# 5. Start the new theme's shell
while IFS= read -r cmd; do
    [[ -n "$cmd" ]] && setsid -f sh -c "$cmd" >/dev/null 2>&1
done < <(shell_field "$THEME_DIR" start)

# 6. Wallpaper: themes with a `wallpaper` in theme.lua get it through awww.
#    Themes whose shell manages wallpaper itself (e.g. Noctalia) leave it unset.
WALLPAPER=$(grep -E '^\s*wallpaper\s*=' "$THEME_DIR/.config/hypr/theme.lua" 2>/dev/null \
    | sed -E 's/.*"(.*)".*/\1/' | sed "s|~|$HOME|" || true)
if [[ -n "$WALLPAPER" ]]; then
    for _ in 1 2 3 4 5 6 7 8 9 10; do awww query >/dev/null 2>&1 && break; sleep 0.2; done
    if [[ -f "$WALLPAPER" ]]; then
        awww img "$WALLPAPER" --transition-fps 255 --transition-type outer --transition-duration 0.8
    else
        echo "Warning: wallpaper not found: $WALLPAPER"
    fi
fi

echo "Switched to theme: $THEME"

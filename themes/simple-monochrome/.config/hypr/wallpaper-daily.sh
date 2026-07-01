#!/usr/bin/env bash
# Picks one wallpaper per calendar day (deterministic) from a cloned wallpaper
# collection and applies it via swww. Same wallpaper all day; changes at midnight.
set -euo pipefail

REPO_URL="https://github.com/Ajaymanikandan0x/hyprland_wallpapers.git"
DEST="$HOME/.local/share/wallpapers/simple-monochrome-wallpaper"
FALLBACK="$HOME/.config/assets/backgrounds/monochrome.png"

if [[ ! -d "$DEST" ]]; then
    git clone --depth 1 "$REPO_URL" "$DEST" 2>/dev/null || true
fi

mapfile -t WALLPAPERS < <(find "$DEST" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) 2>/dev/null | sort)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "Warning: no wallpapers found in $DEST, falling back to static wallpaper"
    CHOSEN="$FALLBACK"
else
    SEED=$(date +%Y%m%d)
    INDEX=$((SEED % ${#WALLPAPERS[@]}))
    CHOSEN="${WALLPAPERS[$INDEX]}"
fi

swww img "$CHOSEN" --transition-fps 255 --transition-type outer --transition-duration 0.8

#!/usr/bin/env bash
# Renders every *.tpl file in this theme against palette.conf.
# Run after editing palette.conf, or automatically via theme-switch.sh.
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PALETTE="$THEME_DIR/palette.conf"

sed_args=()
while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    sed_args+=(-e "s/{{$key}}/$value/g")
done < <(cat "$PALETTE"; echo)

find "$THEME_DIR" -type f -name '*.tpl' | while read -r tpl; do
    out="${tpl%.tpl}"
    sed "${sed_args[@]}" "$tpl" > "$out"
done

echo "Rendered $(find "$THEME_DIR" -name '*.tpl' | wc -l) template(s) from palette.conf"

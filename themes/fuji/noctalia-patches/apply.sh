#!/bin/sh
# Apply fuji's patches to the system Noctalia install (package-owned, needs sudo).
# Rerun after every noctalia-legacy-v4 update; already-applied patches are skipped.
set -e
target=/etc/xdg/quickshell/noctalia-shell
dir=$(dirname "$(readlink -f "$0")")

for p in "$dir"/*.patch; do
    if patch -d "$target" -p1 -R --dry-run -s -f < "$p" >/dev/null 2>&1; then
        echo "already applied: $(basename "$p")"
    else
        sudo patch -d "$target" -p1 -N < "$p"
    fi
done
echo "restart Noctalia (CTRL+Escape) to load the changes"

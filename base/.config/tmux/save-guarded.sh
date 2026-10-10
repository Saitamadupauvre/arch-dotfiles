#!/bin/sh
# Skip saves when only the autostarted "default" session exists, so a fresh
# login doesn't overwrite the last real snapshot.
tmux list-sessions -F '#S' 2>/dev/null | grep -qvx default || exit 0
exec ~/.config/tmux/plugins/tmux-resurrect/scripts/save.sh "$@"

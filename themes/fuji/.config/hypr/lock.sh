#!/bin/sh
# Called by hypridle (lock_cmd) and SUPER+L (shell.lock) — hypridle cannot read shell.lua.
exec qs -c noctalia-shell ipc call lockScreen lock

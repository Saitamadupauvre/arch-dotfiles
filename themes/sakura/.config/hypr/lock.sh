#!/bin/sh
# Called by hypridle (lock_cmd) — hypridle cannot read shell.lua.
exec qs -c noctalia-shell ipc call lockScreen lock

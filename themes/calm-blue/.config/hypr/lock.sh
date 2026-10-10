#!/bin/sh
# Called by hypridle (lock_cmd) — hypridle cannot read shell.lua.
pidof hyprlock || exec hyprlock

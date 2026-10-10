-- Sakura shell: Noctalia (Quickshell) does bar, notifications, launcher, lock screen,
-- session menu and wallpaper (with transitions + colors picked from the wallpaper).
-- Global: read by autostart.lua and binds.lua. theme-switch.sh runs `stop` and `start`
-- through `lua -e` — keep this file free of hl.* calls.
local qs = "qs -c noctalia-shell"

shell = {
    start   = { qs },
    stop    = "qs kill -c noctalia-shell",
    restart = "qs kill -c noctalia-shell; " .. qs,
    menu    = qs .. " ipc call launcher toggle",
    lock    = qs .. " ipc call lockScreen lock",
    logout  = qs .. " ipc call sessionMenu toggle",
}

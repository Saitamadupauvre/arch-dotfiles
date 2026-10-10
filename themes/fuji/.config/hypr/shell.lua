-- Fuji shell: Noctalia (Quickshell) does bar, notifications, launcher, lock screen,
-- session menu, lock screen wallpaper (a still frame of the video, colors picked from it).
-- mpvpaper plays the animated wallpaper on the bottom layer, above Noctalia's wallpaper.
-- Global: read by autostart.lua and binds.lua. theme-switch.sh runs `stop` and `start`
-- through `lua -e` — keep this file free of hl.* calls.
local qs = "qs -c noctalia-shell"
local wall = "env LIBVA_DRIVER_NAME=iHD mpvpaper -l bottom -o 'no-audio loop panscan=1.0 hwdec=vaapi' '*' "
    .. "/home/alban/.config/assets/backgrounds/fuji/twilight-at-mount-fuji.mp4"

shell = {
    start   = { qs, wall },
    stop    = "qs kill -c noctalia-shell; pkill -x mpvpaper",
    restart = "qs kill -c noctalia-shell; " .. qs,
    menu    = qs .. " ipc call launcher toggle",
    lock    = "/home/alban/.config/hypr/lock.sh",
    logout  = qs .. " ipc call sessionMenu toggle",
}

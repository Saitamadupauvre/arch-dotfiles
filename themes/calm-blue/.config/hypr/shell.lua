-- Calm Blue shell: AGS bar, dunst, awww wallpaper, rofi/hyprlock/wlogout.
-- Global: read by autostart.lua and binds.lua. theme-switch.sh runs `stop` and `start`
-- through `lua -e` — keep this file free of hl.* calls.
shell = {
    start = {
        "/usr/bin/dunst",
        "ags run ~/.config/ags",
        "awww-daemon",
    },
    stop    = "pkill -x dunst; pkill -x awww-daemon; ags quit",
    restart = "ags quit; ags run ~/.config/ags",
    menu    = "rofi -show drun -modes drun -theme ~/.config/rofi/calm-blue.rasi",
    lock    = "pidof hyprlock || hyprlock",
    logout  = "wlogout",
}

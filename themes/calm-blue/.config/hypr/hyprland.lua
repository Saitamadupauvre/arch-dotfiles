-- Hyprland reads base + theme files via absolute paths into the dotfiles tree.
local base  = "/home/alban/dotfiles/base/.config/hypr/"
local themeDir = "/home/alban/dotfiles/themes/calm-blue/.config/hypr/"

-- Base — shared, permanent config (keybinds, monitors, env, autostart, programs)
require(base .. "programs")
require(base .. "env")
require(base .. "autostart")
require(base .. "monitors")
require(base .. "workspaces")
require(base .. "binds")
require(base .. "rules")

-- Theme — visuals (colors, wallpaper)
require(themeDir .. "theme")

-- Theme — behavior (animations, gaps, blur, layer rules)
require(themeDir .. "behavior")

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout          = "fr",
        follow_mouse       = 1,
        sensitivity        = 0,
        numlock_by_default = true,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Hyprland reads base + theme files via absolute paths into the dotfiles tree.
-- The active theme name lives in ~/.config/hypr/current-theme (written by theme-switch.sh).
local dotfiles = "/home/alban/dotfiles/"
local base     = dotfiles .. "base/.config/hypr/"

local function activeTheme()
    local f = io.open(os.getenv("HOME") .. "/.config/hypr/current-theme", "r")
    local name = f and f:read("*l")
    if f then f:close() end
    return (name and name ~= "") and name or "calm-blue"
end
local themeDir = dotfiles .. "themes/" .. activeTheme() .. "/.config/hypr/"

-- Theme shell — what the theme launches (bar, notifications, lock, menus). Loaded first:
-- autostart.lua and binds.lua read the `shell` global.
require(themeDir .. "shell")

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

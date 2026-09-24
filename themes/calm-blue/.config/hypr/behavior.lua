-- Calm Blue — behavior

hl.config({
    general = {
        gaps_in          = 4,
        gaps_out         = 8,
        border_size      = 2,
        col = {
            active_border   = theme.active_border,
            inactive_border = theme.inactive_border,
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 16,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        blur = {
            enabled           = true,
            size              = 4,
            passes            = 2,
            new_optimizations = true,
            vibrancy          = 0.25,
            ignore_opacity    = true,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        vrr                      = 0,
    },
})

hl.curve("linear", { type = "bezier", points = { {0, 0},     {1, 1}   } })
hl.curve("snap",   { type = "bezier", points = { {0.2, 0.9}, {0.2, 1} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 4,   bezier = "snap",    style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4,   bezier = "snap",    style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3,   bezier = "snap",    style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3,   bezier = "snap",    style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 1,   bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear",  style = "loop" })
hl.animation({ leaf = "fade",        enabled = true, speed = 6,   bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3,   bezier = "snap" })

for _, ns in ipairs({ "waybar", "rofi", "wlogout", "tofi", "dunst" }) do
    hl.layer_rule({ match = { namespace = ns }, blur = true })
end

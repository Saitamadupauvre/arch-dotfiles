-- Sakura — behavior: soft, slow, floaty motion

hl.config({
    general = {
        gaps_in          = 6,
        gaps_out         = 12,
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
        rounding         = 14,
        active_opacity   = 1.0,
        inactive_opacity = 0.92,

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            vibrancy          = 0.2,
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

hl.curve("linear",  { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("petal",   { type = "bezier", points = { {0.22, 1},    {0.36, 1} } })  -- easeOutQuint
hl.curve("drift",   { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 5,   bezier = "petal",  style = "popin 80%" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 5,   bezier = "petal",  style = "popin 80%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4,   bezier = "drift",  style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4,   bezier = "petal",  style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 2,   bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })
hl.animation({ leaf = "fade",        enabled = true, speed = 5,   bezier = "petal" })
hl.animation({ leaf = "layers",      enabled = true, speed = 4,   bezier = "petal",  style = "fade" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,   bezier = "drift",  style = "slidefade 20%" })

hl.layer_rule({ match = { namespace = "^(noctalia.*)$" }, blur = true, ignore_alpha = 0.3 })
for _, ns in ipairs({ "rofi", "tofi" }) do
    hl.layer_rule({ match = { namespace = ns }, blur = true })
end

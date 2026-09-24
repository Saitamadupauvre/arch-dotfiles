--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Use `hyprctl clients` to find window class names

hl.window_rule({ match = { class = "^(kitty)$" },    opacity = "0.70 0.60" })
hl.window_rule({ match = { class = "^(obsidian)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(obsidian)$" }, float = false })

-- Discord's startup splash: hide only it. Splash title is exactly "Discord";
-- the main window is always "<page> - Discord", so it never matches. Splash closes itself.
hl.window_rule({
    match            = { class = "^(com\\.discordapp\\.Discord)$", title = "^(Discord)$" },
    workspace        = "special:discord-splash silent",
    no_initial_focus = true,
})

-- hl.window_rule({ match = { class = "^(zen-browser)$" }, opacity = "0.90 0.90" })
-- hl.window_rule({ match = { class = "^(Code)$" },        opacity = "0.80 0.80" })
-- hl.window_rule({ match = { class = "^(pavucontrol)$" }, opacity = "0.80 0.70" })
-- hl.window_rule({ match = { class = "^(Spotify)$" },     opacity = "0.70 0.70" })

-- for _, class in ipairs({ "kvantummanager", "qt5ct", "qt6ct", "nwg-look", "pavucontrol",
--                          "blueman-manager", "nm-applet", "nm-connection-editor" }) do
--     hl.window_rule({ match = { class = "^(" .. class .. ")$" }, float = true })
-- end

-- hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

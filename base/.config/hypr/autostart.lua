-------------------
---- AUTOSTART ----
-------------------

-- Runs once at login (equivalent of exec-once)
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    -- Theme shell (bar, notifications, wallpaper daemon...) — see the theme's shell.lua
    for _, cmd in ipairs(shell.start) do
        hl.exec_cmd(cmd)
    end
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Message platforms
    hl.exec_cmd("flatpak run com.discordapp.Discord --start-minimized")
    hl.exec_cmd("teams-for-linux --minimized")

    -- Workspace fill on boot
    hl.exec_cmd(
        programs.terminal .. [[ -e sh -c "tmux has-session -t default 2>/dev/null && tmux respawn-window -k -t default:1 'fastfetch; exec zsh' && tmux attach -t default || tmux new-session -s default 'fastfetch; exec zsh'"]],
        { workspace = "1 silent" }
    )
    hl.exec_cmd(programs.browser, { workspace = "2 silent" })
end)

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local p = programs

local function bind(keys, dsp, opts)
    hl.bind(keys, dsp, opts)
end
local function exec(keys, cmd, opts)
    bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

-- Apps
exec(mainMod .. " + T", p.terminal)
exec(mainMod .. " + B", p.browser)
exec(mainMod .. " + O", p.notes)
exec(mainMod .. " + C", p.editor)
exec(mainMod .. " + S", p.editorAlt)
exec(mainMod .. " + F", p.fileManager)
exec(mainMod .. " + Space", shell.menu)
bind(mainMod .. " + Q", hl.dsp.window.close())
bind(mainMod .. " + M", hl.dsp.exit())
bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))

-- Utilities
exec("SUPER + E", [[rofimoji --selector-args="-theme ~/.config/rofi/emoji.rasi"]])
exec("SUPER + V", "cliphist list | tofi -c ~/.config/tofi/configV | cliphist decode | wl-copy")
exec(mainMod .. " + P", p.colorPicker .. " | wl-copy")

-- System
exec("SUPER + L", shell.lock)
exec("SUPER + ESCAPE", shell.logout)
exec("CTRL + Escape", shell.restart)

-- Screenshots
exec("Print", "grimblast --notify copysave screen")
exec("SUPER + Print", "grimblast --notify copysave active")
exec("SUPER + ALT + Print", "grimblast --notify copysave area")

-- Focus / move windows
for key, dir in pairs({ left = "left", right = "right", up = "up", down = "down" }) do
    bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- Resize windows (repeat while held)
bind(mainMod .. " + CTRL + Right", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })
bind(mainMod .. " + CTRL + Left",  hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
bind(mainMod .. " + CTRL + Up",    hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
bind(mainMod .. " + CTRL + Down",  hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })

-- Workspaces (keycodes 10-19 = number row, layout-independent for AZERTY)
for i = 1, 10 do
    local key = "code:" .. (i + 9)
    bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace
bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Scroll workspaces
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + Z",         hl.dsp.window.drag(),   { mouse = true })
bind(mainMod .. " + X",         hl.dsp.window.resize(), { mouse = true })

-- Volume and Media
exec("XF86AudioRaiseVolume", "pamixer -i 5")
exec("XF86AudioLowerVolume", "pamixer -d 5")
exec("XF86AudioMicMute",     "pamixer --default-source -m")
exec("XF86AudioMute",        "pamixer -t")
exec("XF86AudioPlay",        "playerctl play-pause")
exec("XF86AudioPause",       "playerctl play-pause")
exec("XF86AudioNext",        "playerctl next")
exec("XF86AudioPrev",        "playerctl previous")

-- Brightness
exec("XF86MonBrightnessUp",   "brightnessctl s +5%")
exec("XF86MonBrightnessDown", "brightnessctl s 5%-")

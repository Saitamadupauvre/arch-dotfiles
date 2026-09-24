---------------------
---- MY PROGRAMS ----
---------------------

-- Globals: shared with binds.lua / autostart.lua (each require runs in its own scope,
-- but globals are shared).
programs = {
    terminal    = "kitty",
    fileManager = "nautilus",
    menu        = "rofi -show drun -modes drun -theme ~/.config/rofi/calm-blue.rasi",
    browser     = "zen-browser",
    notes       = "obsidian",
    editor      = "code",
    editorAlt   = "subl",
    colorPicker = "hyprpicker",
}

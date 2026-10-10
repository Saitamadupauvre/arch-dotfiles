# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stow Architecture

Three stow sources, all targeting `$HOME`:

```
dotfiles/
  assets/                            # shared static assets (wlogout icons, backgrounds)
  base/                               # permanent, always-stowed package: keybinds, autostart,
                                       # env vars, monitor/workspace fallbacks, program vars,
                                       # and any config that's identical across every theme
  themes/                            # stow dir for theme packages (only visuals live here)
    .stow                            # marks this as its own stow boundary
    calm-blue/                       # AGS bar + dunst + rofi + hyprlock + wlogout, awww wallpaper
    sakura/                          # Noctalia (Quickshell): bar, notifs, launcher, lock, wallpaper
```

**Active theme** is the name in `~/.config/hypr/current-theme` (written by `theme-switch.sh`).
`base/.config/hypr/hyprland.lua` reads it and requires that theme's `shell`, `theme`, `behavior`.

`base` is never unstowed when switching themes — it holds everything that doesn't change with
the visual theme: keybinds, window rules, autostart daemons, env vars, generic monitor/workspace
fallbacks, program variables (`$terminal`, `$browser`, etc.), and any app config (waybar layout,
wlogout layout, GTK chrome/settings, shared rofi templates) that doesn't carry theme colors.

Each theme package under `themes/` is small and only contains what actually changes with the
theme: colors, wallpaper, blur/gaps/animation feel, and files that embed color values directly
(waybar `style.css`, dunst `dunstrc`, tofi configs, wlogout `style.css`, btop theme + `color_theme`
line, rofi color palette `.rasi`, ghostty `config`, hypr `theme.conf`/`behavior.conf`/`hyprlock.conf`).

**Always stow with `--no-folding`** — packages share `.config/<tool>/` directory names. Without
`--no-folding`, stow creates a single directory symlink that conflicts between `base` and `themes/*`.

```bash
# Apply shared assets (one-time)
stow --dir=~/dotfiles --target=$HOME --no-folding assets

# Apply base (one-time, permanent — do this before stowing any theme)
stow --dir=~/dotfiles --target=$HOME --no-folding base

# Apply a theme
stow --dir=~/dotfiles/themes --target=$HOME --no-folding calm-blue

# Switch themes (recommended — never touches base)
~/.config/hypr/theme-switch.sh calm-blue

# Remove a theme
stow --dir=~/dotfiles/themes --target=$HOME -D calm-blue
```

## Base Contents

| Tool | Files |
|---|---|
| hypr | hyprland.lua, binds.lua, rules.lua, env.lua, autostart.lua, monitors.lua, workspaces.lua, programs.lua, hypridle.conf, theme-switch.sh, theme-picker.sh (SUPER+SHIFT+T, tofi) |
| wlogout | layout |
| rofi | template/rounded-template.rasi, and shared palette rasi files not tied to the active theme |
| gtk-3.0 | gtk.css, colors.css, settings.ini, window_decorations.css, assets/ |
| gtk-4.0 | colors.css, settings.ini, window_decorations.css |
| nvim | init.lua, lua/config/, lua/plugins/ (minus colorscheme.lua and lualine.lua), README.md, lazy-lock.json |
| root | .gtkrc-2.0 |

`base/.config/gtk-3.0/colors.css` and `gtk-4.0/colors.css` are Breeze system-theme colors, not
our color scheme — identical across all themes historically, so they live in base, not per-theme.

## Theme Contents

Each theme dir (`themes/<name>/`) contains only visual overrides:

| Tool | Files |
|---|---|
| hypr | shell.lua (what the theme runs), lock.sh (for hypridle), theme.lua (borders, optional wallpaper), behavior.lua (gaps/blur/animations/layer rules) |
| waybar | style.css |
| dunst | dunstrc |
| tofi | configA, configV |
| wlogout | style.css |
| btop | btop.conf, themes/<name>.theme |
| rofi | `<name>.rasi` (imports `~/.config/rofi/template/rounded-template.rasi` from base) |
| ghostty | config |
| nvim | lua/plugins/colorscheme.lua (colorscheme+style), lua/plugins/lualine.lua (statusline theme) |

Per-theme extras: calm-blue also ships `ags/`, dunst, tofi, rofi, wlogout, hyprlock, waybar css,
`palette.conf` + `*.tpl` + `generate.sh`. sakura ships `noctalia/settings.json` (colors from
wallpaper; wallpapers in `~/.config/assets/backgrounds/sakura/`) + palette/tpl for kitty/tofi.
Each theme has a `.stow-local-ignore` (ignores `.*\.tpl`, `generate.sh`, `palette.conf`).

### Theme shell contract (`shell.lua`)

```lua
shell = {
    start   = { "cmd", ... },  -- autostart.lua runs these at login; theme-switch.sh after switch
    stop    = "cmd",           -- theme-switch.sh runs the OLD theme's stop
    restart = "cmd",           -- CTRL+Escape
    menu    = "cmd",           -- SUPER+Space
    lock    = "cmd",           -- SUPER+L (hypridle uses lock.sh instead)
    logout  = "cmd",           -- SUPER+Escape
}
```
No `hl.*` calls in shell.lua — theme-switch.sh reads it with plain `lua`.
AGS runs as `gjs -m .../ags.js` — stop it with `ags quit`, not `pkill -f 'ags run'`.

## Hyprland-specific Quirks

**Lua config** (Hyprland 0.55+): hyprlang `.conf` is deprecated for Hyprland itself (dropped ~0.57).
Hyprland loads `~/.config/hypr/hyprland.lua` in preference to `hyprland.conf` when both exist.
hyprlock/hypridle/hyprpaper still use hyprlang — keep `hyprlock.conf`/`hypridle.conf` as-is.
API reference: `/usr/share/hypr/hyprland.lua` (example) and `/usr/share/hypr/stubs/hl.meta.lua`.

**Validate before reloading**: `Hyprland --verify-config` (optionally `-c <file>`) — strict, catches
unknown keys/fields, out-of-range values, and Lua errors in required files.

**Require paths**: `hyprland.lua` requires base then theme files via absolute paths (no `.lua` extension),
base first so the theme loads last:
```lua
local base     = "/home/alban/dotfiles/base/.config/hypr/"
local themeDir = dotfiles .. "themes/" .. activeTheme() .. "/.config/hypr/"
require(themeDir .. "shell")
require(base .. "programs")   -- then env, autostart, monitors, workspaces, binds, rules
require(themeDir .. "theme")  -- then behavior
```
Each `require` runs in its own scope; share values via globals: `shell` (shell.lua → binds/autostart),
`programs` (programs.lua → binds/autostart) and `theme` (theme.lua → behavior.lua).

**`hypridle.conf` is not loaded by `hyprland.lua`** — it's the standalone `hypridle` daemon's
own config file (launched via `autostart.lua`), not a Hyprland config fragment.

**Autostart**: `exec-once` → `hl.exec_cmd(...)` inside `hl.on("hyprland.start", function() ... end)`.
Workspace rules for launched apps: `hl.exec_cmd(cmd, { workspace = "2 silent" })`.

**Reload after stow**: Stow changes don't auto-apply. Run `hyprctl reload` after any hypr config change.

**Window rules** (Lua):
```lua
hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.70 0.60" })
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
```

## Adding a New Theme

Copy the existing theme and modify only the color/behavior files — base stays untouched:

```bash
cp -r ~/dotfiles/themes/calm-blue ~/dotfiles/themes/<name>
# edit: hypr/theme.lua.tpl, hypr/behavior.lua, hypr/hyprlock.conf, waybar/style.css,
#       dunst/dunstrc, tofi/configA, tofi/configV, wlogout/style.css,
#       btop/btop.conf + btop/themes/<name>.theme, rofi/<name>.rasi, ghostty/config
# edit hypr/shell.lua + hypr/lock.sh if the theme uses a different shell
~/.config/hypr/theme-switch.sh <name>   # no arg = list themes
```

`theme-switch.sh` (in base): dry-run stow conflict check → old theme's `shell.stop` → `generate.sh`
→ unstow all themes, stow new → write `current-theme` → `hyprctl reload` → new `shell.start` →
awww wallpaper only if theme.lua has `wallpaper = "..."`.

## calm-blue Palette

Black/white/gray everywhere, with a single neon-violet accent (`#b45cff`) reserved for: the
focused window border, waybar's active/focused workspace pill, and dunst's critical-urgency
notification frame. Nothing else (rofi, tofi, wlogout, gtk, ghostty palette, inactive border)
uses the accent color.

## Pending / Known Issues

- `assets` package not stowed: `~/.config/assets/wlogout/` was root-owned. Fix: `sudo rm -rf ~/.config/assets && stow --dir=~/dotfiles --target=$HOME --no-folding assets`
- `lock-hover.png` missing from `assets/.config/assets/wlogout/assets/`
- Wallpaper paths in `hyprlock.conf` (`monochrome.png`, `monochrome_blurred.png`) reference `~/.config/assets/backgrounds/` which doesn't exist yet — no backgrounds directory
- `gtk-4.0/gtk.css` and `gtk-4.0/gtk-dark.css` are system symlinks to `/usr/share/themes/Breeze/gtk-4.0/` — not tracked here by design
- `assets/.config/assets/backgrounds/sakura/` is empty — add sakura wallpapers for Noctalia

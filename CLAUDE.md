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
    calm-blue/                # complete theme: colors + wallpaper + a few theme-only files
```

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
| hypr | binds.lua, rules.lua, env.lua, autostart.lua, autostart.sh, monitors.lua, workspaces.lua, programs.lua, hypridle.conf, theme-switch.sh |
| waybar | config.jsonc (module layout) |
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
| hypr | theme.lua (+ theme.lua.tpl; colors, wallpaper), behavior.lua (gaps/blur/rounding/animations/layer rules), hyprlock.conf |
| waybar | style.css |
| dunst | dunstrc |
| tofi | configA, configV |
| wlogout | style.css |
| btop | btop.conf, themes/<name>.theme |
| rofi | `<name>.rasi` (imports `~/.config/rofi/template/rounded-template.rasi` from base) |
| ghostty | config |
| nvim | lua/plugins/colorscheme.lua (colorscheme+style), lua/plugins/lualine.lua (statusline theme) |

`themes/<name>/.config/hypr/hyprland.lua` is the one file that lives in the theme dir but isn't
a visual override — it `require`s both `base/` and the theme's own files by absolute path
(see Lua config below).

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
local themeDir = "/home/alban/dotfiles/themes/<name>/.config/hypr/"
require(base .. "programs")   -- then env, autostart, monitors, workspaces, binds, rules
require(themeDir .. "theme")  -- then behavior
```
Each `require` runs in its own scope; share values via globals: `programs` (programs.lua → binds/autostart)
and `theme` (theme.lua → behavior.lua).

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
# update themeDir in hypr/hyprland.lua (<old-name> → <name>)
~/.config/hypr/theme-switch.sh <name>
```

`theme-switch.sh` (lives in `base/.config/hypr/`, so it's available regardless of which theme is
active) unstows all packages under `themes/`, stows the new one, applies wallpaper, reloads hyprland.

## calm-blue Palette

Black/white/gray everywhere, with a single neon-violet accent (`#b45cff`) reserved for: the
focused window border, waybar's active/focused workspace pill, and dunst's critical-urgency
notification frame. Nothing else (rofi, tofi, wlogout, gtk, ghostty palette, inactive border)
uses the accent color.

## Pending / Known Issues

- `assets` package not stowed: `~/.config/assets/wlogout/` was root-owned. Fix: `sudo rm -rf ~/.config/assets && stow --dir=~/dotfiles --target=$HOME --no-folding assets`
- `lock-hover.png` missing from `assets/.config/assets/wlogout/assets/`
- Wallpaper paths in `theme.conf`/`hyprlock.conf` (`monochrome.png`, `monochrome_blurred.png`) reference `~/.config/assets/backgrounds/` which doesn't exist yet — no backgrounds directory
- `gtk-4.0/gtk.css` and `gtk-4.0/gtk-dark.css` are system symlinks to `/usr/share/themes/Breeze/gtk-4.0/` — not tracked here by design

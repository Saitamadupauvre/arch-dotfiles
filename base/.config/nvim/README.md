# My Neovim config

A clean, modular Neovim setup. The guiding rule: **one plugin = one file** in
`lua/plugins/`. To add a feature you drop a file; to remove it you delete the
file. There is no central list to keep in sync.

## How it's organized

```
~/.config/nvim/
├── init.lua              # entry point: sets <leader>, loads config + plugins
├── lua/
│   ├── config/
│   │   ├── options.lua   # editor settings (numbers, tabs, clipboard, ...)
│   │   ├── keymaps.lua   # global keybindings
│   │   └── lazy.lua      # installs the plugin manager, auto-loads plugins/
│   └── plugins/          # ONE FILE PER PLUGIN (auto-imported)
│       ├── colorscheme.lua
│       ├── treesitter.lua   # syntax highlighting
│       ├── telescope.lua     # fuzzy finder
│       ├── neo-tree.lua      # file explorer
│       ├── lsp.lua           # language servers (autocomplete brains)
│       ├── completion.lua    # autocomplete popup
│       ├── formatting.lua    # format on save
│       ├── gitsigns.lua      # git changes in the gutter
│       ├── lualine.lua       # status line
│       └── editor.lua        # which-key, autopairs, comments
├── lazy-lock.json       # auto-generated: pins exact plugin versions
└── README.md
```

### How loading works
1. `init.lua` runs first → sets the leader key (Space) → loads `config/`.
2. `config/lazy.lua` installs **lazy.nvim** (the plugin manager) on first launch,
   then calls `require("lazy").setup({ { import = "plugins" } })`.
3. That `import` line loads **every** `.lua` file in `lua/plugins/`. Each file
   returns a *spec* (a Lua table describing a plugin), and lazy.nvim installs
   and configures it.

## Changing things

**Edit a setting** → `lua/config/options.lua` (e.g. tab width, line numbers).

**Add or change a global shortcut** → `lua/config/keymaps.lua`.

**Add a plugin** → create `lua/plugins/NAME.lua`:
```lua
return {
  "owner/repo",          -- the GitHub path of the plugin
  opts = {},             -- options passed to the plugin's setup()
}
```
Save, restart Neovim. lazy.nvim installs it automatically.

**Remove a plugin** → delete its file in `lua/plugins/`, restart.

**Disable a plugin temporarily** → add `enabled = false` to its spec.

**Add a language server (LSP)** → add its name to `ensure_installed` in
`lua/plugins/lsp.lua`. Run `:Mason` to see all available servers.

**Add a formatter** → add it under the filetype in `lua/plugins/formatting.lua`.

## Useful commands (type them in normal mode)
- `:Lazy` — plugin manager UI (install / update / clean / profile)
- `:Mason` — install/manage language servers, formatters, linters
- `:checkhealth` — diagnose problems with the config or plugins
- `:LspInfo` — see which language server is attached to the current file

## Key bindings (leader = Space)
Press `<Space>` and pause — **which-key** shows everything live.

| Keys          | Action                       |
| ------------- | ---------------------------- |
| `<leader>ff`  | Find files                   |
| `<leader>fg`  | Find text (grep)             |
| `<leader>fb`  | Find open buffers            |
| `<leader>fr`  | Recent files                 |
| `<leader>e`   | Toggle file explorer         |
| `<leader>w`   | Save file                    |
| `<leader>q`   | Quit window                  |
| `<leader>f`   | Format buffer                |
| `gd`          | Go to definition             |
| `gr`          | List references              |
| `K`           | Hover documentation          |
| `<leader>rn`  | Rename symbol                |
| `<leader>ca`  | Code action                  |
| `[d` / `]d`   | Prev / next diagnostic       |
| `gcc`         | Toggle comment on line       |
| `]c` / `[c`   | Next / prev git change       |
| `<leader>hs`  | Stage git hunk               |
| `<leader>hp`  | Preview git hunk             |
| `<C-h/j/k/l>` | Move between windows         |
| `<S-h>/<S-l>` | Previous / next buffer       |

## Requirements
- Neovim 0.10+ (you have 0.12.2 ✓)
- `git`, `ripgrep` (rg), `fd` — already installed ✓
- `tree-sitter` CLI — needed to compile syntax parsers on Neovim 0.11+.
  Install with `sudo pacman -S tree-sitter-cli` or `cargo install tree-sitter-cli`.
- A **Nerd Font** in your terminal for icons (https://www.nerdfonts.com).
  Without one, icons show as boxes — everything still works.
- Optional: `lazygit` for a full git TUI (`sudo pacman -S lazygit`).

## First launch
Run `nvim`. lazy.nvim bootstraps and installs all plugins (let it finish), then
language servers install in the background via Mason. Restart once when done.
Run `:checkhealth` to confirm everything is green.

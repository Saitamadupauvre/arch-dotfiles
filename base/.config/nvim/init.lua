-- init.lua — the very first file Neovim reads.
-- Keep it tiny: set the leader key, then hand off to lua/config/.
--
-- The leader key is a prefix you press before custom shortcuts.
-- We use Space. This MUST be set before plugins load, so it lives here.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard = "unnamedplus"

-- Load editor options and global keymaps (files in lua/config/).
require("config.options")
require("config.keymaps")

-- Bootstrap the plugin manager and load everything in lua/plugins/.
require("config.lazy")

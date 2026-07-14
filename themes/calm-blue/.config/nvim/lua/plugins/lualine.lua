-- lualine.lua — the status line at the bottom (mode, file, git branch,
-- diagnostics, position). Purely cosmetic; tweak `theme` to taste.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- icons (needs a Nerd Font)
  event = "VeryLazy", -- load after startup, when nvim is idle
  opts = {
    options = {
      theme = "tokyonight",
      globalstatus = true, -- one status line for all windows
    },
  },
}

-- editor.lua — small quality-of-life plugins bundled in one file.
-- (Multiple plugins in one file is fine: just return a list of specs.)
return {
  -- which-key: a popup that shows what keys you can press next. Press <leader>
  -- and wait — it lists every shortcut. Best learning tool for a new config.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- autopairs: auto-close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Comment: toggle comments with `gcc` (line) or `gc` in visual mode.
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- vim-tmux-navigator: seamless Ctrl-hjkl pane switching between nvim
  -- splits and tmux panes (tmux side already set up in ~/.config/tmux).
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- auto-save: saves buffer on InsertLeave / TextChanged / focus lost.
  {
    "pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {},
  },
}

-- colorscheme.lua — the editor theme.
-- To try another theme: change the repo + the `colorscheme` name below,
-- or add a new file in lua/plugins/ for a different theme.
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- load during startup (themes shouldn't be lazy-loaded)
  priority = 1000, -- load before everything else so colors apply early
  config = function()
    require("tokyonight").setup({
      style = "night", -- options: "storm", "night", "moon", "day"
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}

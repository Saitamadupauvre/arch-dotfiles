-- telescope.lua — fuzzy finder. Search files, text, buffers, and more.
-- Uses ripgrep (rg) and fd under the hood (both already installed).
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim", -- shared Lua helper library
    -- Native C sorter = much faster matching. `make` compiles it.
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  -- Lazy-load on these keys. Pressing one loads the plugin then runs the action.
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find text (grep)" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find open buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Find diagnostics" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf") -- enable the native sorter if built
  end,
}

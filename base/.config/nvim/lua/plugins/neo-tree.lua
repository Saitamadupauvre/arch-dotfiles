-- neo-tree.lua — file explorer sidebar.
-- Toggle with <leader>e. Inside the tree: a=add, d=delete, r=rename, ?=help.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- file type icons (needs a Nerd Font)
    "MunifTanjim/nui.nvim",        -- UI component library
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
  },
  opts = {
    close_if_last_window = true, -- close nvim if the tree is the last window
    filesystem = {
      follow_current_file = { enabled = true }, -- highlight the open file
      use_libuv_file_watcher = true,            -- auto-refresh on disk changes
      filtered_items = { hide_dotfiles = false, hide_gitignored = false },
    },
  },
}

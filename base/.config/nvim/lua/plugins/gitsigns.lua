-- gitsigns.lua — shows git changes in the left gutter (added/changed/removed
-- lines) and lets you stage/reset/preview individual hunks.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(keys, fn, desc)
        vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "Git: " .. desc })
      end
      map("]c", gs.next_hunk, "Next change")
      map("[c", gs.prev_hunk, "Previous change")
      map("<leader>hs", gs.stage_hunk, "Stage hunk")
      map("<leader>hr", gs.reset_hunk, "Reset hunk")
      map("<leader>hp", gs.preview_hunk, "Preview hunk")
      map("<leader>hb", gs.blame_line, "Blame line")
    end,
  },
}

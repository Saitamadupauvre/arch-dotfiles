-- completion.lua — the autocomplete popup as you type.
--   nvim-cmp           -> the completion engine
--   LuaSnip            -> snippet engine (expandable code templates)
--   friendly-snippets  -> a big library of ready-made snippets
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- load when you start typing
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",  -- completions from language servers
    "hrsh7th/cmp-buffer",    -- words in the current buffer
    "hrsh7th/cmp-path",      -- filesystem paths
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    "saadparwaiz1/cmp_luasnip", -- bridge: snippets as completion source
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load the friendly-snippets library.
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),      -- manually trigger menu
        ["<C-e>"] = cmp.mapping.abort(),             -- close menu
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept selection
        ["<Tab>"] = cmp.mapping(function(fallback)   -- Tab: next item / jump snippet
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback) -- Shift-Tab: previous
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}

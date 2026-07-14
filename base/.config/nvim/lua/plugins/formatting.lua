-- formatting.lua — auto-format code on save with conform.nvim.
-- Each filetype maps to one or more formatters. Missing formatters are
-- skipped silently — install them via :Mason or your system package manager.
-- Manual format anytime with <leader>f.
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- load just before saving
  keys = {
    {
      "<leader>f",
      function() require("conform").format({ async = true, lsp_fallback = true }) end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt" },
      rust = { "rustfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      cs = { "csharpier" },
      python = { "ruff_format" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true, -- use the LSP formatter if no formatter is set
    },
  },
}

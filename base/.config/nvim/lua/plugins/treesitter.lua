-- treesitter.lua — smart syntax highlighting + indentation.
-- It parses code into a tree, giving far better highlighting than regex.
--
-- NOTE: Neovim 0.11+ needs the `main` branch of nvim-treesitter (a rewrite).
-- The old `master` branch crashes on recent Neovim. The `main` branch compiles
-- parsers with the `tree-sitter` CLI, so that must be installed (see README).
--
-- Add a language: add its name to `ensure` below, save, then run :TSInstall <lang>
-- (or just restart — missing parsers in the list auto-install on startup).
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate", -- recompile installed parsers after plugin updates
  config = function()
    require("nvim-treesitter").setup()

    local ensure = {
      "lua", "vim", "vimdoc", "query",
      "go", "rust", "c", "cpp", "c_sharp",
      "python", "javascript", "typescript", "tsx",
      "html", "css", "json", "yaml", "toml", "markdown", "markdown_inline",
      "bash", "gitignore",
    }

    -- Install any missing parsers (needs the `tree-sitter` CLI). Runs async.
    if vim.fn.executable("tree-sitter") == 1 then
      local installed = require("nvim-treesitter.config").get_installed()
      local lookup = {}
      for _, l in ipairs(installed) do lookup[l] = true end
      local todo = {}
      for _, l in ipairs(ensure) do
        if not lookup[l] then table.insert(todo, l) end
      end
      if #todo > 0 then require("nvim-treesitter").install(todo) end
    end

    -- Start highlighting per buffer. The `main` branch no longer does this
    -- automatically — you start it on the FileType event.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        pcall(vim.treesitter.start, ev.buf, lang)
      end,
    })
  end,
}

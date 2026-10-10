-- lsp.lua — Language Server Protocol = the brains behind go-to-definition,
-- hover docs, rename, diagnostics, and code actions for each language.
--
-- Three pieces work together:
--   mason.nvim          -> installs the language servers (the binaries)
--   mason-lspconfig     -> bridges Mason names to lspconfig + auto-enables them
--   nvim-lspconfig      -> the actual server configurations
--
-- Add a language server: add its name to `ensure_installed` below, save,
-- restart, then run :Mason to watch it install. Browse servers with :Mason.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp", -- tells servers what completion features we support
    },
    config = function()
        -- Completion capabilities advertised to every server (from nvim-cmp).
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Set buffer-local keymaps whenever any server attaches. Using the
        -- LspAttach autocmd instead of vim.lsp.config's on_attach because the
        -- latter isn't reliably invoked for servers auto-enabled by
        -- mason-lspconfig.
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local map = function(keys, fn, desc)
                    vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "LSP: " .. desc })
                end
                map("gd", vim.lsp.buf.definition, "Go to definition")
                map("gD", vim.lsp.buf.declaration, "Go to declaration")
                map("gr", vim.lsp.buf.references, "List references")
                map("gi", vim.lsp.buf.implementation, "Go to implementation")
                map("K", vim.lsp.buf.hover, "Hover docs")
                map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                map("<leader>cd", vim.diagnostic.open_float, "Show line diagnostics")
            end,
        })

        -- Apply these defaults to every server lspconfig configures.
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",        -- Lua (this config)
                "gopls",         -- Go
                "rust_analyzer", -- Rust
                "clangd",        -- C / C++
                "omnisharp",     -- C#
                "pyright",       -- Python
                "ts_ls",         -- JavaScript / TypeScript
                "html",          -- HTML
                "cssls",         -- CSS
                "tailwindcss",   -- Tailwind CSS class intellisense
                "emmet_ls",      -- Emmet abbreviations (HTML/CSS/JSX)
                "marksman",      -- Markdown
            },
            -- mason-lspconfig auto-enables each installed server with the
            -- defaults set via vim.lsp.config("*", ...) above.
        })

        -- Per-server tweaks. lua_ls needs to know about the `vim` global.
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = { diagnostics = { globals = { "vim" } } },
            },
        })

        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                "--background-index",
                "--compile-commands-dir=build/mcu",
                "--query-driver=/usr/bin/g++,/usr/bin/clang++,/usr/bin/gcc,/usr/bin/arm-none-eabi-gcc,/opt/gbdk/bin/lcc",
            },
            root_markers = { "Makefile", ".git", ".clangd", "CMakeLists.txt" },
        })
    end,
}

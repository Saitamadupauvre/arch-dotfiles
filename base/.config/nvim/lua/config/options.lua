-- options.lua — editor behavior. Change defaults here.
-- `vim.opt.X = Y` is the Lua way to write the old `:set X=Y`.
-- One option per line, commented so you know what each does.

local opt = vim.opt

-- Line numbers
opt.number = true          -- show absolute line number on current line
opt.relativenumber = true  -- other lines numbered relative to cursor (great for motions)

-- Indentation
opt.tabstop = 2            -- a <Tab> looks 2 spaces wide
opt.shiftwidth = 2         -- one indent step = 2 spaces
opt.expandtab = true       -- pressing <Tab> inserts spaces, not a tab char
opt.smartindent = true     -- auto-indent new lines sensibly

-- Search
opt.ignorecase = true      -- case-insensitive search...
opt.smartcase = true       -- ...unless you type an uppercase letter
opt.hlsearch = true        -- highlight all matches
opt.incsearch = true       -- show matches as you type

-- UI
opt.termguicolors = true   -- enable 24-bit colors (needed by colorschemes)
opt.signcolumn = "yes"     -- always show the left gutter (avoids text shifting)
opt.cursorline = true      -- highlight the line the cursor is on
opt.scrolloff = 8          -- keep 8 lines visible above/below cursor
opt.wrap = false           -- don't wrap long lines
opt.splitright = true      -- vertical splits open on the right
opt.splitbelow = true      -- horizontal splits open below

-- Behavior
opt.mouse = "a"            -- enable the mouse in all modes
opt.clipboard = "unnamedplus" -- use the system clipboard for yank/paste
opt.undofile = true        -- persist undo history across restarts
opt.swapfile = false       -- no .swp files
opt.updatetime = 250       -- faster CursorHold events (used by LSP, gitsigns)
opt.timeoutlen = 400       -- ms to wait for a mapped key sequence (which-key popup)

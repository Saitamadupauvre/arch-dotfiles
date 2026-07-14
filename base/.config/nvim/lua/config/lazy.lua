-- lazy.lua — installs the lazy.nvim plugin manager (once), then tells it
-- to load EVERY file inside lua/plugins/. That auto-import is the magic
-- that makes adding a plugin = dropping a new file in lua/plugins/.

-- 1. Bootstrap: clone lazy.nvim on first launch if it's missing.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- 2. Add lazy.nvim to the runtime path so `require("lazy")` works.
vim.opt.rtp:prepend(lazypath)

-- 3. Start lazy. `import = "plugins"` loads every lua/plugins/*.lua file.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- Check for plugin updates in the background, but don't auto-install them.
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})

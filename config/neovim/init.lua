--[[-- Neovim Lua startup configuration file

  Mainly just download and execute `lazy.nvim`.
  Also loads `system` which determine system and system options
  from environment variables `$SYSTEM` and `$SYSTEM_OPTIONS`.

--]]

vim.g.mapleader = " " -- Should be set before loading `lazy`

local system = require("system")

if not system.is_nix then
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.rtp:prepend(lazypath)

  ---@diagnostic disable-next-line: undefined-field
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    if system.has_self_install then
      local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
      })
      if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { out, "WarningMsg" },
          { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
      end
    else
      vim.api.nvim_echo({
        { "Plugin `lazy.nvim` not installed/found in: ", "ErrorMsg" },
        { lazypath, "ErrorMsg" },
        { "\nSystem cannot install, install it manually", "WarningMsg" },
        { "\nNeovim can be started without config with: " },
        { "nvim --clean" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  require("lazy").setup({
    spec = {
      { import = "lazy.plugins" },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = {
      missing = system.has_self_install,
    },
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
    ui = {
      border = "rounded",
    },
  })
end -- `not system.is_nix`

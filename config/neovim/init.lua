--[[-- Neovim Lua startup configuration file

  Mainly just download and execute `lazy.nvim`.
  Also determine system and system options from environment variables.

  Most of the classic Vim stuff is in `./plugin` (see `./plugin/options`, e.g.)
  while plugin configuration are in `./lua/custom/plugin/<plugin-name>`.

  References:
  - https://github.com/tjdevries/config.nvim/blob/master/init.lua
  - https://github.com/ThePrimeagen/init.lua/blob/master/init.lua
--]]

vim.g.mapleader = " " -- Love having it accessible from both hands, sorry comma

-- # System recognition from environment variables -------------------------------------------------

vim.g.system = os.getenv("SYSTEM") or "unknown"

local system_options = os.getenv("SYSTEM_OPTIONS") or ""
local options_list = {}
for option in string.gmatch(system_options, "([^:]+)") do
  table.insert(options_list, option)
end
vim.g.system_options = options_list

-- # Lazy setup ------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

require("lazy").setup({
  spec = {
    { import = "custom.plugins" },
  },
  checker = { enabled = false },
  change_detection = { notify = false, },
})

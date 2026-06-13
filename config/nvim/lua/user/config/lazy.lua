local M = {}

local sinfo = vim.g.sinfo
local lazy_root = vim.fn.stdpath("data") .. "/site/lazy"
local lazy_path = lazy_root .. "/lazy.nvim"

---Bootstrap plugin manager
function M.bootstrap()
  ---@diagnostic disable-next-line: undefined-field
  local lazy_exists = vim.uv.fs_stat(lazy_path) ~= nil

  if not lazy_exists then
    if not sinfo.is_offline then
      vim.notify("Installing lazy.nvim...", vim.log.levels.INFO)
      local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazy_path,
      })
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to clone `lazy.nvim`:\n" .. out, vim.log.levels.ERROR)
        return false
      end
    else
      vim.notify(
        "`lazy.nvim` not found and and system cannot self-install.\n"
          .. "Please install manually or start with: nvim --clean",
        vim.log.levels.ERROR
      )
      return false
    end
  end

  vim.opt.rtp:prepend(lazy_path)
  return true
end

if M.bootstrap() then
  require("lazy").setup(
    ---@module "lazy.types"
    ---@type LazyConfig
    {
      root = lazy_root,
      lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
      spec = {
        { import = "user.plugins.lazy" },
        { import = "user.plugins.lazy.languages" },
      },
      rocks = { enabled = false },
      install = { missing = not sinfo.is_offline },
      checker = { enabled = not sinfo.is_offline and not sinfo.is_slow, notify = false },
      change_detection = { enabled = false },
    }
  )
end

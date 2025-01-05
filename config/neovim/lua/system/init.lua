local M = {}

-- # System recognition from environment variables

vim.g.system = os.getenv("SYSTEM") or "unknown"

local system_options = os.getenv("SYSTEM_OPTIONS") or ""
local options_list = {}
for option in string.gmatch(system_options, "([^:]+)") do
  table.insert(options_list, option)
end
vim.g.system_options = options_list

-- # Nix (stuff) detection

M.is_nix = os.getenv("NVIM_NIX_WRAPPER") or vim.fn.executable("nix") and true or false
if M.is_nix then
  M.nix_plugins_path = os.getenv("NVIM_NIX_PLUGINS_PATH")
      ---@diagnostic disable-next-line: undefined-field
      and vim.loop.fs_stat(os.getenv("NVIM_NIX_PLUGINS_PATH"))
      and os.getenv("NVIM_NIX_PLUGINS_PATH")
    or nil

  -- TODO: speedup Lazy Nix install detection by passing an environment from Nix wrapper?
  ---@diagnostic disable-next-line: undefined-field
  M.lazy_nix_installed = M.nix_plugins_path and vim.loop.fs_stat(M.nix_plugins_path .. "/lazy.nvim") ~= nil
end

function M.set_if_nix(nix, non_nix)
  if M.is_nix then
    return nix
  else
    return non_nix
  end
end

-- # WSL detection and clipboard setup

M.is_wsl = os.getenv("WSL_DISTRO_NAME") and true or false

if M.is_wsl then
  vim.g.clipboard = {
    name = "WSLClipboard",
    copy = {
      ["+"] = "win32yank.exe -i",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

-- # Utility function/variables

M.is_offline = vim.tbl_contains(vim.g.system_options, "offline")
M.has_self_install = not M.is_offline

M.is_ssh = os.getenv("SSH_CONNECTION") and true or false

---@diagnostic disable-next-line: param-type-mismatch
M.site_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")

return M

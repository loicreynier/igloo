local M = {}

-- # System recognition from environment variables

vim.g.system = os.getenv("SYSTEM") or "unknown"
M.name = vim.g.system
M.arch = vim.loop.os_uname().machine

local system_options = os.getenv("SYSTEM_OPTIONS") or ""
local options_list = {}
for option in string.gmatch(system_options, "([^:]+)") do
  table.insert(options_list, option)
end
vim.g.system_options = options_list

-- # Nix (stuff) detection

M.is_nix = os.getenv("NVIM_NIX_WRAPPER") ~= nil or vim.fn.executable("nix") == 1
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

if M.name == "HPCC_Turpan" and vim.fn.executable("rsclip") == 1 and os.getenv("DISPLAY") then
  vim.g.clipboard = {
    name = "SSHClipboard",
    copy = {
      ["+"] = "rsclip",
    },
    paste = {
      ["+"] = "rsclip -p",
    },
  }
end

-- # Utility function/variables

M.is_offline = vim.tbl_contains(vim.g.system_options, "offline")
M.is_hpcc = vim.tbl_contains(vim.g.system_options, "hpcc")
M.has_self_install = not M.is_offline
M.is_slow = vim.tbl_contains(vim.g.system_options, "slow")

M.is_ssh = os.getenv("SSH_CONNECTION") and true or false

M.use_mason = M.has_self_install and not M.is_nix
M.has_node = vim.fn.executable("node")

---@diagnostic disable-next-line: param-type-mismatch
M.site_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")

M.treesitter_install_dir = vim.fs.joinpath(M.site_dir, "treesitter")
M.treesitter_parsers_ensure_installed = M.has_self_install and "all" or {}
M.treesitter_parsers_installed = {}

return M

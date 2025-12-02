local M = {}

--[[-- System recognition from environment variables -----------------------------------------------------------------]]

---System ID deduced from `$SYSTEM`
---@type string
M.name = "unknown"

---System architecture
---@type string
M.arch = "unknown"

local function get_system_info()
  M.name = os.getenv("SYSTEM") or "unknown"
  M.arch = vim.loop.os_uname().machine

  local system_options = os.getenv("SYSTEM_OPTIONS") or ""
  local options_list = {}
  for option in string.gmatch(system_options, "([^:]+)") do
    table.insert(options_list, option)
  end
  ---System options list deduced from `$SYSTEM_OPTIONS`
  ---@type string[]
  M.system_options = options_list

  ---Whether system if offline
  ---@type boolean
  M.is_offline = vim.tbl_contains(M.system_options, "offline")

  ---Whether system is a HPCC
  ---@type boolean
  M.is_hpcc = vim.tbl_contains(M.system_options, "hpcc")

  ---Whether system is a potato
  ---@type boolean
  M.is_slow = vim.tbl_contains(M.system_options, "slow")

  ---Whether system is a SSH remote
  ---@type boolean
  M.is_ssh = os.getenv("SSH_CONNECTION") and true or false

  ---Whether system is a WSL
  ---@type boolean
  M.is_wsl = os.getenv("WSL_DISTRO_NAME") and true or false

  ---Whether system can install program by itself (without relying on Nix)
  ---@type boolean
  M.has_self_install = not M.is_offline

  ---Whether system has Node
  ---@type boolean
  M.has_node = vim.fn.executable("node") == 1

  ---Whether system (Neovim) will use Mason to install software
  ---@type boolean
  M.use_mason = M.has_self_install and not M.is_nix
end

--[[-- Nix detection and setup ---------------------------------------------------------------------------------------]]

---Whether system has Nix or Neovim is Nix wrapped
---@type boolean
M.is_nix = false

local function get_nix_info()
  M.is_nix = os.getenv("NVIM_NIX_WRAPPER") ~= nil or vim.fn.executable("nix") == 1

  if M.is_nix then
    -- Check path validity
    M.nix_plugins_path = os.getenv("NVIM_NIX_PLUGINS_PATH")
        ---@diagnostic disable-next-line: param-type-mismatch
        and vim.loop.fs_stat(os.getenv("NVIM_NIX_PLUGINS_PATH"))
        and os.getenv("NVIM_NIX_PLUGINS_PATH")
      or nil

    -- TODO: speedup Lazy Nix install detection by passing an environment from Nix wrapper?
    ---@diagnostic disable-next-line: undefined-field
    M.lazy_nix_installed = M.nix_plugins_path and vim.loop.fs_stat(M.nix_plugins_path .. "/lazy.nvim") ~= nil
  end
end

---Return `nix` is system has Nix or `non_nix` otherwise
---@type fun(nix: any, non_nix:any): any
function M.set_if_nix(nix, non_nix)
  if M.is_nix then
    return nix
  else
    return non_nix
  end
end

--[[-- GLIBC version detection (async) -------------------------------------------------------------------------------]]

---GLIBC version deduced from `ldd --version`
---@type string?
M.glibc = nil

local function get_glibc_version()
  vim.system({ "ldd", "--version" }, { text = true }, function(obj)
    if obj.code == 0 then
      local version = obj.stdout:match("GNU libc%)%s*(%d+%.%d+)")
      if version then M.glibc = version end
    end
  end)
end

--[[-- Utility functions/variables -----------------------------------------------------------------------------------]]

M.site_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")

--[[-- Setup function ------------------------------------------------------------------------------------------------]]

function M.setup()
  get_nix_info()
  get_system_info()
  get_glibc_version()
end

return M

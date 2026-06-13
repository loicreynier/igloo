local M = {}

---@class SystemInfo
---@field name string System ID (from `$SYSTEM`)
---@field arch string Hardware architecture (e.g., "x86_64")
---@field options string[] List of system options (from `$SYSTEM_OPTIONS`)
---@field is_offline boolean Whether the system is offline
---@field is_hpcc boolean Whether the system is a HPCC
---@field is_wsl boolean Whether the system is WSL
---@field is_slow boolean Whether the system is a potato
---@field is_ssh boolean Whether the system/session is over SSH
---@field is_nix boolean Whether the system is Nix-based
---@field has_node boolean Whether the system has `node` command

---@type SystemInfo
M.info = {
  name = "unknown",
  arch = "unknown",
  options = {},
  has_node = false,
  is_offline = false,
  is_hpcc = false,
  is_slow = false,
  is_ssh = false,
  is_wsl = false,
  is_nix = false,
}

---Get system information and populate `M.info`
local function get_system_info()
  M.info.name = os.getenv("SYSTEM") or "unknown"
  ---@diagnostic disable-next-line: undefined-field
  M.info.arch = vim.uv.os_uname().machine:lower() or "unknown"

  local system_options = os.getenv("SYSTEM_OPTIONS") or ""
  M.info.options = {}
  for option in string.gmatch(system_options, "([^:]+)") do
    table.insert(M.info.options, option)
  end
  M.info.is_offline = vim.tbl_contains(M.info.options, "offline")
  M.info.is_hpcc = vim.tbl_contains(M.info.options, "hpcc")
  M.info.is_slow = vim.tbl_contains(M.info.options, "slow")

  M.info.is_ssh = os.getenv("SSH_CONNECTION") ~= nil
  M.info.is_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil
  M.info.has_node = vim.fn.executable("node") == 1

  M.info.is_nix = vim.fn.executable("nix") == 1
end

function M.setup()
  get_system_info()
  vim.g.sinfo = M.info
end

return M

local M = {}

-- # System recognition from environment variables

vim.g.system = os.getenv("SYSTEM") or "unknown"

local system_options = os.getenv("SYSTEM_OPTIONS") or ""
local options_list = {}
for option in string.gmatch(system_options, "([^:]+)") do
  table.insert(options_list, option)
end
vim.g.system_options = options_list

-- # Nix detection

M.is_nix = os.getenv("NVIM_NIX_WRAPPER") and true or false

function M.set_if_nix(nix, non_nix)
  if M.is_nix then
    return nix
  else
    return non_nix
  end
end

-- # Utility function/variables

M.has_self_install = not (M.is_nix or vim.tbl_contains(vim.g.system_options, "offline"))

M.is_ssh = os.getenv("SSH_CONNECTION") and true or false

return M

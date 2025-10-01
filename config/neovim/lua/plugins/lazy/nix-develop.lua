---@type LazySpec
local spec = {}

if require("system").is_nix then spec = {
  "figsoda/nix-develop.nvim",
  cmd = { "NixDevelop", "NixShell" },
  config = function() end,
}
end

return spec

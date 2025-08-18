---@type LazySpec
return {
  "figsoda/nix-develop.nvim",
  enabled = require("system").is_nix,
  cmd = { "NixDevelop", "NixShell" },
  config = function() end,
}

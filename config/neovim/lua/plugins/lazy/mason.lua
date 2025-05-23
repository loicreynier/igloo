local system = require("system")

return {
  "mason-org/mason.nvim",
  enabled = system.has_self_install and not system.is_nix,
  build = ":MasonUpdate",
  cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  opts = {
    registries = {
      -- "file:~/git/neovim/mason-registry",
      "github:mason-org/mason-registry",
    },
    install_root_dir = vim.fs.joinpath(system.site_dir, "mason"),
  },
  config = function(_, opts) require("mason").setup(opts) end,
}

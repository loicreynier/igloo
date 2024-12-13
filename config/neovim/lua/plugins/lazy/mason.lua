local system = require("system")

return {
  "williamboman/mason.nvim",
  enabled = system.has_self_install,
  build = ":MasonUpdate",
  cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog", },
  opts = {
    install_root_dir = vim.fs.joinpath(system.site_dir, "mason"),
  },
  config = function(_, opts)
    require("mason").setup(opts)
  end,
}


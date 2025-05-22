---@type LazySpec
return {
  "polirritmico/telescope-lazy-plugins.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<Leader>sL", "<Cmd>Telescope lazy_plugins<CR>", desc = "Search Lazy plugins specs (Telescope)" },
  },
  opts = function()
    local opts
    ---@module "telescope._extensions.lazy_plugins"
    ---@type TelescopeLazyPluginsUserConfig
    opts = {
      lazy_config = vim.fn.stdpath("config") .. "/lua/config/lazy.lua",
    }
    return { extensions = { lazy_plugins = opts } }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("lazy_plugins")
  end,
}

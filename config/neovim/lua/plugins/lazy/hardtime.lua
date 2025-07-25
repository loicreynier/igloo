---@type LazySpec
return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  enabled = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    disabled_filetypes = require("utils").disabled_filetypes,
    disable_mouse = false,
  },
}

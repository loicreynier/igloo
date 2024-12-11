local utils = require("utils")

return {
  "NMAC427/guess-indent.nvim",
  lazy = false,
  cmd = "GuessIndent",
  opts = {
    auto_cmd = true,
    buftype_exclude = utils.disabled_buftypes,
    filetype_exclude = utils.disabled_filetypes,
  },
  config = function(_, opts) require("guess-indent").setup(opts) end,
}

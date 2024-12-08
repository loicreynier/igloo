local utils = require("utils")

return {
  "mcauley-penney/visual-whitespace.nvim",
  opts = {
    excluded = {
      filetypes = utils.disabled_filetypes,
      buftypes = utils.disabled_buftypes,
    },
  },
  config = function() require("visual-whitespace").setup({}) end,
}

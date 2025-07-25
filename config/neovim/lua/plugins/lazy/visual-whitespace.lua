local utils = require("utils")
local branch_ = vim.fn.has("nvim-0.11") == 1 and "main" or "compat-v10"

return {
  "mcauley-penney/visual-whitespace.nvim",
  branch = branch_,
  opts = {
    excluded = {
      filetypes = utils.disabled_filetypes,
      buftypes = utils.disabled_buftypes,
    },
  },
  config = function() require("visual-whitespace").setup({}) end,
}

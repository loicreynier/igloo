local indent_size = require("utils").indent_size(2)

vim.opt_local.shiftwidth = indent_size
vim.opt_local.tabstop = indent_size
vim.opt_local.formatoptions:remove("o")

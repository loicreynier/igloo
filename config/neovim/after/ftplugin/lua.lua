local indent_size = require("utils").indent_size(2)
local text_width = require("utils").text_width(120)
vim.opt_local.shiftwidth = indent_size
vim.opt_local.tabstop = indent_size
vim.bo.textwidth = text_width

vim.keymap.set({ "n" }, "<Leader>x", ":.lua<CR>", { desc = "Execute the current line (Lua)" })
vim.keymap.set({ "v" }, "<leader>x", ":lua<Cr>", { desc = "execute selection (lua)" })
vim.keymap.set({ "n" }, "<Leader>X", "<Cmd>source %<CR>", { desc = "Execute/source current file (Lua)" })

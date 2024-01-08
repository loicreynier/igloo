vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
vim.keymap.set("n", "h", api.tree.close, opts("Close"))
vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))

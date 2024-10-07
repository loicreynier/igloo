local set = vim.keymap.set

-- # Escaping insert mode
vim.keymap.set({"i", "c"}, "jj", "<Esc>")
vim.keymap.set("t", "kj", "<C-\\><C-n>")
vim.keymap.set("i", "<C-c>", "<Esc>")

-- # Insert mode Emacs-like motions
vim.keymap.set({"i", "c", "t"}, "<C-a>", "<Home>", {desc = "Beginning of line"})
vim.keymap.set({"i", "c", "t"}, "<C-e>", "<End>", {desc = "End of line"})
vim.keymap.set({"i", "c", "t"}, "<C-f>", "<Right>", {desc = "Move forward"})
vim.keymap.set({"i", "c", "t"}, "<C-b>", "<Left>", {desc = "Move backward"})

-- # Yanking, pasting & register stuff
vim.keymap.set({"n", "v",}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+yg_]]) -- Last visual selection
vim.keymap.set("n", "<leader>yy", [["+yy]]) -- Entire line
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])
vim.keymap.set({"n", "v"}, "<leader>P", [["+P]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) -- Embrace the void

-- # Completion & wildmenu
vim.keymap.set({"i", "c", "t"}, "<C-o>", "<S-Tab>")

vim.keymap.set("c", "<C-p>", function()
  return vim.fn.wildmenumode() == 1 and "<Left>" or "<Up>"
end, { expr = true })

vim.keymap.set("c", "<C-n>", function()
  return vim.fn.wildmenumode() == 1 and "<Right>" or "<Down>"
end, { expr = true })

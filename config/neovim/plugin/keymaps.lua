local set = vim.keymap.set
local set_api = vim.api.nvim_set_keymap

-- # Azerty keyboard
-- TODO: add test if keyboard is Azerty
set_api("n", "ù", "[", {})
set_api("n", "*", "]", {})

-- # Escaping insert mode
set({"i", "c"}, "jj", "<Esc>")
set("t", "kj", "<C-\\><C-n>")
set("i", "<C-c>", "<Esc>")

-- # Insert mode Emacs-like motions
set({"i", "c", "t"}, "<C-a>", "<Home>", {desc = "Beginning of line"})
set({"i", "c", "t"}, "<C-e>", "<End>", {desc = "End of line"})
set({"i", "c", "t"}, "<C-f>", "<Right>", {desc = "Move forward"})
set({"i", "c", "t"}, "<C-b>", "<Left>", {desc = "Move backward"})

-- # Yanking, pasting & register stuff
set({"n", "v",}, "<Leader>y", [["+y]])
set("n", "<Leader>Y", [["+yg_]]) -- Last visual selection
set("n", "<Leader>yy", [["+yy]]) -- Entire line
set({"n", "v"}, "<Leader>p", [["+p]])
set({"n", "v"}, "<Leader>P", [["+P]])

set({"n", "v"}, "<Leader>d", [["_d]]) -- Embrace the void

-- # Completion & wildmenu
set({"i", "c", "t"}, "<C-o>", "<S-Tab>")

set("c", "<C-p>", function()
  return vim.fn.wildmenumode() == 1 and "<Left>" or "<Up>"
end, { expr = true })

set("c", "<C-n>", function()
  return vim.fn.wildmenumode() == 1 and "<Right>" or "<Down>"
end, { expr = true })

-- # Windows and buffers
set({"n"}, "<Leader>q", "<Cmd>bdelete<CR>", {desc="Delete current buffer"})

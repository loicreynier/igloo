local set = vim.keymap.set
local set_api = vim.api.nvim_set_keymap

-- # Azerty keyboard
-- TODO: add test if keyboard is Azerty
set_api("n", "ù", "[", {})
set_api("n", "*", "]", {})

-- # Escaping insert mode
set({ "i", "c" }, "jj", "<Esc>")
set("t", "kj", "<C-\\><C-n>")
set("i", "<C-c>", "<Esc>")

-- # Insert mode Emacs-like motions
set({ "i", "c", "t" }, "<C-a>", "<Home>", { desc = "Beginning of line" })
set({ "i", "c", "t" }, "<C-e>", "<End>", { desc = "End of line" })
set({ "i", "c", "t" }, "<C-f>", "<Right>", { desc = "Move forward" })
set({ "i", "c", "t" }, "<C-b>", "<Left>", { desc = "Move backward" })

-- # Yanking, pasting & register stuff
set({ "n", "v" }, "<Leader>y", [["+y]])
set("n", "<Leader>Y", [["+yg_]]) -- Last visual selection
set("n", "<Leader>yy", [["+yy]]) -- Entire line
set({ "n", "v" }, "<Leader>p", [["+p]])
set({ "n", "v" }, "<Leader>P", [["+P]])

set({ "n", "v" }, "<Leader>d", [["_d]]) -- Embrace the void

-- # Completion & wildmenu
set({ "i", "c", "t" }, "<C-o>", "<S-Tab>")

set("c", "<C-p>", function() return vim.fn.wildmenumode() == 1 and "<Left>" or "<Up>" end, { expr = true })

set("c", "<C-n>", function() return vim.fn.wildmenumode() == 1 and "<Right>" or "<Down>" end, { expr = true })

-- # Windows and buffers
set("n", "<Leader>bb", "<Cmd>e #<CR>", { desc = "Switch to other buffer" })
set("n", "[b", "<Cmd>bprevious<CR>", { desc = "Switch to previous buffer" })
set("n", "]b", "<Cmd>bnext<CR>", { desc = "Switch to next buffer" })
set("n", "<Leader>bd", "<Cmd>bdelete<CR>", { desc = "Delete current buffer" })

-- # LSP
-- TODO: better visibility toggle
-- Two keymaps as there is no built-in variable to track visibility
-- See: https://github.com/neovim/neovim/issues/14825
set("", "<Leader>cd", function() vim.diagnostic.show() end, { desc = "Show code diagnostics" })
set("", "<Leader>cD", function() vim.diagnostic.hide() end, { desc = "Hide code diagnostics" })

local M = {}

local set = vim.keymap.set
local set_api = vim.api.nvim_set_keymap
local diag = vim.diagnostic
local lsp = vim.lsp

M.leader = " "

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

-- # Diagnostics
set("n", "]d", function()
  diag.jump({ diagnostic = diag.get_next() })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Go to next diagnostic and center" })
set("n", "[d", function()
  diag.jump({ diagnostic = diag.get_prev() })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Go to previous diagnostic and center" })
set("n", "]e", function()
  diag.jump({ diagnostic = diag.get_next({ severity = diag.severity.ERROR }) })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Go to next error and center" })
set("n", "[e", function()
  diag.jump({ diagnostic = diag.get_prev({ severity = diag.severity.ERROR }) })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Go to previous error and center" })
set("n", "]w", function()
  diag.jump({ diagnostic = diag.get_next({ severity = diag.severity.WARN }) })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Go to next warning and center" })
set("n", "[w", function()
  diag.jump({ diagnostic = diag.get_prev({ severity = diag.severity.WARN }) })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Go to previous warning and center" })
--  `<Leader>cd` toggles diagnostics, see Snacks
set(
  "n",
  "<Leader>cD",
  function() diag.open_float({ border = "rounded" }) end,
  { desc = "Open diagnostic float with rounded border" }
)

-- # LSP (per-buffer bindings)
M.map_lsp_keybinds = function(bufnr)
  local telescope = require("telescope.builtin")
  -- Code actions
  set("n", "<Leader>ca", function() lsp.buf.code_action() end, { desc = "Apply code actions (LSP)", buffer = bufnr })
  set("n", "<Leader>cr", function() lsp.buf.rename() end, { desc = "Rename symbol (LSP)", buffer = bufnr })
  -- Hover
  set(
    "n",
    "<Leader>K",
    function() lsp.buf.hover({ border = "rounded" }) end,
    { desc = "Display symbol hover information (LSP)", buffer = bufnr }
  )
  set(
    "n",
    "<C-k>",
    function() lsp.buf.signature_help({ border = "rounded" }) end,
    { desc = "Display smybol signature help (LSP)", buffer = bufnr }
  )
  -- Definitions & references
  set("n", "gD", function() lsp.buf.declaration() end, { desc = "Go to symbol declaration (LSP)", buffer = bufnr })
  set("n", "gd", function()
    -- lsp.buf.definition()
    telescope.lsp_definitions()
  end, { desc = "Go to symbol definition (LSP)", buffer = bufnr })
  set("n", "gr", function()
    -- lsp.buf.references()
    telescope.lsp_references()
  end, { desc = "List symbol references (LSP)", buffer = bufnr })
  set("n", "gT", function()
    -- lsp.buf.type_definition()
    telescope.lsp_type_definition()
  end, { desc = "Go to type definition (LSP)", buffer = bufnr })
  set("n", "gI", function()
    -- lsp.buf.implementation()
    telescope.lsp_implementations()
  end, { desc = "List symbol implementations (LSP)", buffer = bufnr })
end

return M

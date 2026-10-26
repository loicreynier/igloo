local M = {}

local set = vim.keymap.set
local del = vim.keymap.del
local set_api = vim.api.nvim_set_keymap

M.leader = vim.g.mapleader

-- Azerty
-- TODO: replace by langmap when https://github.com/neovim/neovim/pull/40148 is released (0.12.4)
-- vim.opt.langmap = "ù[,*]"
set_api("n", "ù", "[", {})
set_api("n", "*", "]", {})
set_api("n", "ùù", "[[", {})
set_api("n", "**", "]]", {})

-- Insert mode ---------------------------------------------------------------------------------------------------------

-- Escaping
set({ "i", "c" }, "jj", "<Esc>")
set("t", "kj", "<C-\\><C-n>")
set("i", "<C-c>", "<Esc>")

-- Emacs-like motion
set({ "i", "c", "t" }, "<C-a>", "<Home>", { desc = "Beginning of line" })
set({ "i", "c", "t" }, "<C-e>", "<End>", { desc = "End of line" })
set({ "i", "c", "t" }, "<C-f>", "<Right>", { desc = "Move forward" })
set({ "i", "c", "t" }, "<C-b>", "<Left>", { desc = "Move backward" })

-- Normal mode ---------------------------------------------------------------------------------------------------------

-- Smart wrapped-lines navigation
set("n", "j", function()
  if vim.v.count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true })
set("n", "k", function()
  if vim.v.count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true })

-- Registers -----------------------------------------------------------------------------------------------------------

set({ "n", "v" }, "<Leader>y", [["+y]], { desc = "Yank to system clipboard" })
set({ "n", "v" }, "<Leader>p", [["+p]], { desc = "Paste from system clipboard after cursor" })
set({ "n", "v" }, "<Leader>P", [["+P]], { desc = "Paste from system clipboard beore cursor" })

set({ "n", "v" }, "<Leader>d", [["_d]], { desc = "Delete to black hole register" })

-- Completion ----------------------------------------------------------------------------------------------------------

set("c", "<C-o>", function() return vim.fn.wildmenumode() == 1 and "<S-Tab>" end, { expr = true })
set("c", "<C-p>", function() return vim.fn.wildmenumode() == 1 and "<Left>" or "<Up>" end, { expr = true })
set("c", "<C-n>", function() return vim.fn.wildmenumode() == 1 and "<Right>" or "<Down>" end, { expr = true })

-- Diagnostics ---------------------------------------------------------------------------------------------------------

local diagnos = vim.diagnostic
local maps = {
  { key = "d", label = "diagnostic", severity = nil },
  { key = "e", label = "error", severity = diagnos.severity.ERROR },
  { key = "w", label = "warning", severity = diagnos.severity.WARN },
  { key = "i", label = "info", severity = diagnos.severity.INFO },
  { key = "h", label = "hint", severity = diagnos.severity.HINT },
}

for _, m in ipairs(maps) do
  local function jump(count, wrap)
    local opts = { count = count, wrap = wrap }

    if m.severity then opts.severity = m.severity end

    diagnos.jump(opts)
  end

  local label = m.label

  set("n", "]" .. m.key, function() jump(vim.v.count1) end, { desc = "Next " .. label })

  set("n", "[" .. m.key, function() jump(-vim.v.count1) end, { desc = "Previous " .. label })

  local key_upper = m.key:upper()

  set("n", "]" .. key_upper, function() jump(vim._maxint, false) end, { desc = "Last " .. label })

  set("n", "[" .. key_upper, function() jump(-vim._maxint, false) end, { desc = "First " .. label })
end

-- LSP -----------------------------------------------------------------------------------------------------------------

local lsp = vim.lsp

set("i", "<C-Space>", function() lsp.completion.get() end, { desc = "Trigger LSP completion" })

-- Disable default LSP mappings
del("n", "gra")
del("n", "gri")
del("n", "grn")
del("n", "grr")
del("n", "grt")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp_attach.keymaps", { clear = true }),
  callback = function(event)
    local buffer = event.buf

    set("n", "<Leader>ca", lsp.buf.code_action, { desc = "Apply code actions (LSP)", buffer = buffer })
    set("n", "<Leader>cr", lsp.buf.rename, { desc = "Rename symbol (LSP)", buffer = buffer })
    set("n", "K", lsp.buf.hover, { desc = "Hover documentation (LSP)", buffer = buffer })
    set("n", "gD", lsp.buf.declaration, { desc = "Go to symbol declaration (LSP)", buffer = buffer })

    if package.loaded["telescope"] then
      require("user.plugins.config.pickers").set_pickers_lsp_keymaps()
    else
      set("n", "gd", lsp.buf.definition, { desc = "Go to symbol declaration (LSP)", buffer = buffer })
      set("n", "gr", lsp.buf.references, { desc = "Go to symbol references (LSP)", buffer = buffer })
    end
  end,
})

-- Filetype-specific mappings ------------------------------------------------------------------------------------------

-- Execute current line or current file (Lua & Vim)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "vim" },
  group = vim.api.nvim_create_augroup("user.keymaps.execute_file", { clear = true }),
  callback = function()
    -- Execute current line
    set("n", "<Leader>x", function()
      local filetype = vim.bo.filetype
      if filetype == "lua" then
        vim.cmd(".lua")
      elseif filetype == "vim" then
        vim.cmd(".source")
      end
    end, { desc = "Execute the current line", buffer = true, silent = true })

    -- Execute current file
    set("n", "<Leader>X", "<Cmd>source %<CR>", { desc = "Execute the current file", buffer = true, silent = true })
  end,
})

-- Close Vim help with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  callback = function() vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true, silent = true }) end,
})

return M

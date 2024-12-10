vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- TODO: better visibility toggle
-- Two keymaps as there is no built-in variable to track visibility
-- See: https://github.com/neovim/neovim/issues/14825
vim.keymap.set("", "<Leader>cd", function() vim.diagnostic.show() end, { desc = "Show code diagnostics" })
vim.keymap.set("", "<Leader>cD", function() vim.diagnostic.hide() end, { desc = "Hide code diagnostics" })

local icons = require("user.rice").icons

-- Diagnostics ---------------------------------------------------------------------------------------------------------

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    current_line = false,
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  virtual_lines = {
    current_line = true,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
})

-- LSP -----------------------------------------------------------------------------------------------------------------

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { desc = "Show LSP info" })
vim.api.nvim_create_user_command(
  "LspLog",
  function() vim.cmd(string.format("edit %s", vim.fs.joinpath(vim.fn.stdpath("log"), "lsp.log"))) end,
  { desc = "Show LSP log" }
)
vim.api.nvim_create_user_command("LspRestart", "lsp restart", { desc = "Restart LSP" })
vim.api.nvim_create_user_command("LspStop", "lsp stop", { desc = "Restart LSP" })

if vim.env.GHOSTTY_BIN_DIR ~= nil then
  vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(event)
      local value = event.data.params.value
      vim.api.nvim_echo({ { value.message or "done" } }, false, {
        id = "lsp." .. event.data.client_id,
        kind = "progress",
        source = "vim.lsp",
        title = value.title,
        status = value.kind ~= "end" and "running" or "success",
        percent = value.percentage,
      })
    end,
    desc = "LSP: Show progress",
  })
end

if vim.g.cmp_engine == "nvim" then
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      end
    end,
    desc = "LSP: Enable auto-trigger completion",
  })
end

vim.lsp.enable({
  "clangd",
  "lua_ls",
  -- "ffmt",
  "fortls",
  "fortitude",
  "jsonls",
  "ltex",
  "neocmakelsp",
  "nil_ls",
  "ruff",
  "stylua",
  "taplo",
  "texlab",
  "ty",
  "typos_lsp",
})

-- Disable Fortitude's hover in favor of `fortls`
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp_attach.disable_fortitude_hover", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "fortitude" then client.server_capabilities.hoverProvider = false end
  end,
  desc = "LSP: Disable hover capability from Fortitude",
})

-- Disable LuaLS highlighting of TODO comments
-- See: https://github.com/stsewd/tree-sitter-comment/issues/22
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp_attach.disable_luals_hlcomments", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "lua_ls" then vim.api.nvim_set_hl(0, "@lsp.type.comment.lua", {}) end
  end,
  desc = "LSP: Disable Lua comments highlighting (LuaLS breaks TODO comments)",
})

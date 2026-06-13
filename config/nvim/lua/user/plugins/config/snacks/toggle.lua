local M = {}

M.init = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      local format = require("user.utils.format")
      format.snacks_toggle():map("<Leader>uf")
      format.snacks_toggle(true):map("<Leader>uF")
    end,
  })

  vim.api.nvim_create_user_command("ToggleDiagnostics", function() Snacks.toggle.diagnostics():toggle() end, {})
  vim.api.nvim_create_user_command("ToggleIndentGuides", function() Snacks.toggle.indent():toggle() end, {})
  vim.api.nvim_create_user_command("ToggleZenMode", function() Snacks.toggle.zen():toggle() end, {})
end

return M

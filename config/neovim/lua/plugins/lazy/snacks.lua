--- @type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<Leader>cd", "<Cmd>ToggleDiagnostics<CR>", desc = "Toggle diagnostics (Snacks)" },
  },
  --- @type snacks.Config
  opts = {
    toggle = { enabled = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local format = require("utils.format")
        format.snacks_toggle():map("<Leader>uf")
        format.snacks_toggle(true):map("<Leader>uF")
      end,
    })

    vim.api.nvim_create_user_command("ToggleDiagnostics", function() Snacks.toggle.diagnostics():toggle() end, {})
  end,
}

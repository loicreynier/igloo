---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<Leader>bd", function() Snacks.bufdelete.delete() end, desc = "Delete current buffer (Snacks)" },
    {
      "<Leader>bD",
      function() Snacks.bufdelete.other() end,
      desc = "Delete all buffers except the current one (Snacks)",
    },
    { "<Leader>bX", function() Snacks.bufdelete.all() end, desc = "Delete all buffers (Snacks)" },
    { "<Leader>cd", "<Cmd>ToggleDiagnostics<CR>", desc = "Toggle diagnostics (Snacks)" },
    { "<Leader>ui", "<Cmd>ToggleIndentGuides<CR>", desc = "Toggle indent guides (Snacks)" },
    { "<Leader>uz", "<Cmd>ToggleZenMode<CR>", desc = "Toggle zen mode (Snacks)" },
  },
  ---@type snacks.Config
  opts = {
    toggle = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    zen = {
      toggles = {
        dim = false,
      },
      win = {
        backdrop = {
          transparent = false,
          blend = 95,
        },
        width = 0.60,
      },
      show = {
        statusline = false,
        tabline = false,
      },
    },
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
    vim.api.nvim_create_user_command("ToggleIndentGuides", function() Snacks.toggle.indent():toggle() end, {})
    vim.api.nvim_create_user_command("ToggleZenMode", function() Snacks.toggle.zen():toggle() end, {})
  end,
}

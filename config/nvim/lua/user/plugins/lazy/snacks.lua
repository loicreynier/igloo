---@module "lazy.types"
---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  dependencies = {
    "folke/todo-comments.nvim", -- Enables TODO picker
  },
  lazy = false,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5 MiB
    },
    dashboard = require("user.plugins.config.snacks.dashboard"),
    input = { enabled = true },
    notifier = {
      enabled = true,
      margin = { top = 1, right = 1, bottom = 0 },
    },
    picker = require("user.plugins.config.snacks.picker"),
    terminal = { enabled = false },
    word = { enabled = false },
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
    require("user.plugins.config.snacks.toggle").init()
    vim.api.nvim_create_user_command(
      "Bdelete",
      function(opts) Snacks.bufdelete.delete({ force = opts.bang == true }) end,
      { bang = true }
    )
    vim.api.nvim_create_user_command("SnacksPick", function() Snacks.picker.pick() end, {})
  end,
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
    { "<Leader>un", function() Snacks.notifier.hide() end, desc = "Hide notification (Snacks)" },
    { "<Leader>uN", function() Snacks.notifier.show_history() end, desc = "Hide notification (Snacks)" },
  },
}

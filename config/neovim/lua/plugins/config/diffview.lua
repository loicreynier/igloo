-- Inspired from:
-- https://github.com/disrupted/dotfiles/blob/master/.config/nvim/lua/conf/diffview.lua
-- TODO: configure my own keymaps & fix next/prev conflict action ?

local actions = require("diffview.actions")

---@module "diffview.config"
---@type DiffviewConfig
local opts = {
  use_icons = true,
  show_help_hints = true,
  enhanced_diff_hl = true,
  diff_binaries = false,
  file_panel = {
    listing_style = "tree",
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded",
    },
  },
  view = {
    default = {
      disable_diagnostics = true,
    },
    merge_tool = {
      disable_diagnostics = true,
    },
  },
  keymaps = {
    disable_defaults = false,
    _shared = {
      {
        "n",
        "q",
        vim.cmd.tabclose,
        { desc = "Close Diffview" },
      },
    },
    view = {
      {
        "n",
        "]q",
        actions.select_next_entry,
        { desc = "Next file", remap = true },
      },
      {
        "n",
        "[q",
        actions.select_prev_entry,
        { desc = "Prev file", remap = true },
      },
      {
        "n",
        "]x",
        actions.next_conflict,
        { desc = "Next conflict", remap = true },
      },
      {
        "n",
        "[x",
        actions.prev_conflict,
        { desc = "Prev conflict", remap = true },
      },
    },
    file_panel = {},
    file_history_panel = {},
  },
}

vim.list_extend(opts.keymaps.view, opts.keymaps._shared)
vim.list_extend(opts.keymaps.file_panel, opts.keymaps._shared)
vim.list_extend(opts.keymaps.file_history_panel, opts.keymaps._shared)
opts.keymaps._shared = nil

return opts

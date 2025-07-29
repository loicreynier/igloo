local rice = require("rice")
local system = require("system")
local icons = rice.icons
local use_mason = system.has_self_install and not system.is_nix

local sections_presets = {
  doom = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    { section = "startup" },
  },
}

---@class snacks.dashboard.Config
return {
  width = rice.header.width + 4,
  preset = {
    header = rice.header.string,
    pick = "telescope",
    keys = {
      {
        icon = icons.actions.new_file,
        key = "n",
        desc = "New File",
        action = ":ene | startinsert",
      },
      {
        icon = icons.actions.find_files,
        key = "f",
        desc = "Find File",
        action = function() Snacks.dashboard.pick("files") end,
      },
      {
        icon = icons.actions.find_text,
        key = "g",
        desc = "Find Text",
        action = function() Snacks.dashboard.pick("live_grep") end,
      },
      {
        icon = icons.actions.recent_files,
        key = "r",
        desc = "Recent Files",
        action = function() Snacks.dashboard.pick("oldfiles") end,
      },
      {
        icon = icons.actions.projects,
        key = "p",
        desc = "Projects",
        action = function() Snacks.dashboard.pick("projects") end,
      },
      {
        icon = icons.actions.config_files,
        key = "c",
        desc = "Config",
        action = function() Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") }) end,
      },
      {
        icon = icons.actions.restore_session,
        key = "s",
        desc = "Restore Session",
        section = "session",
      },
      {
        icon = icons.plugins.Lazy,
        key = "L",
        desc = "Lazy",
        action = ":Lazy",
        ---@diagnostic disable-next-line: undefined-global, undefined-field
        enabled = package.loaded.lazy ~= nil,
      },
      {
        icon = icons.plugins.Mason,
        key = "M",
        desc = "Mason",
        action = ":Mason",
        enabled = use_mason,
      },
      {
        icon = icons.actions.quit,
        key = "q",
        desc = "Quit",
        action = ":qa",
      },
    },
  },
  sections = sections_presets.doom,
}

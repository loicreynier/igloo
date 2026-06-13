local header = require("user.rice").header

local sections_presets = {
  doom = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
    { section = "startup" },
  },
}

---@module "snacks"
---@type snacks.dashboard.Config
---@diagnostic disable-next-line: missing-fields
return {
  enabled = false,
  sections = sections_presets.doom,
  width = header.width + 4,
  preset = {
    header = header.string,
  },
}

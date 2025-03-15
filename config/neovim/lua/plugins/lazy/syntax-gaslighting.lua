return {
  "NotAShelf/syntax-gaslighting.nvim",
  event = "VeryLazy",
  enabled = false, -- Enable when filetype-based ignoring works
  opts = {
    gaslighting_chance = 1,
    merge_messages = true,
    filetypes_to_ignore = require("utils").disabled_filetypes, -- Doesn't work?
  },
}

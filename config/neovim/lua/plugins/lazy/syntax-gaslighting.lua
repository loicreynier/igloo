return {
  "NotAShelf/syntax-gaslighting.nvim",
  event = "VeryLazy",
  opts = {
    -- gaslighting_chance = 5,
    merge_messages = true,
    filetypes_to_ignore = require("utils").disabled_filetypes,
  },
}

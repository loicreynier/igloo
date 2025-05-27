return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
  },
  keys = {
    {
      "<Leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Show Buffer Local Keymaps (WhichKey)",
    },
  },
}

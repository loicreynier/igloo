return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "TodoTrouble", "TodoTelescope" },
  opts = {},
  keys = {
    {
      "]t",
      function() require("todo-comments").jump_next() end,
      desc = "Next TODO comment",
    },
    {
      "[t",
      function() require("todo-comments").jump_prev() end,
      desc = "Previous TODO comment",
    },
    {
      "<Leader>st",
      "<Cmd>TodoTelescope<CR>",
      desc = "Find todo comments (Telescope)",
    },
    {
      "<Leader>xt",
      "<Cmd>TodoTrouble toggle<CR>",
      desc = "Toggle TODO comments panel (Trouble)",
    },
  },
}

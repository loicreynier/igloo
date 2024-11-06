--[[-- yanky

  Better yank/paste

  TODO: needs to be configured
  - keymaps
  - pasting from system clipboard

--]]

return {
  "gbprod/yanky.nvim",
  desc = "Better yank/paste",
  enabled = false,
  event = "BufReadPost",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<Leader>sy",
      function() require("telescope").extensions.yank_history.yank_history({}) end,
      mode = { "n", "x" },
      desc = "Open yank history (Telescope)",
    },
  },
  opts = {
    highlight = {
      timer = 500,
      on_put = true,
      on_yank = true,
    },
  },
}

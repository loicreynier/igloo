return {
  "tris203/precognition.nvim",
  event = "VeryLazy",
  init = function()
    vim.keymap.set("n", "<Leader>up", "<cmd>Precognition toggle<CR>", { desc = "Toggle navigation hints (Precognition)" })
  end,
  opts = {
    startVisible = false,
    disable_fts = require("utils").disabled_filetypes,
  },
  config = function(_, opts)
    require("precognition").setup(opts)
  end,
}

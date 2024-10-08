-- Plugins related to core Vim mechanisms
return {
  {
    "famiu/bufdelete.nvim",
    keys = {
      {
        "<Leader>Q",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        desc = "Delete current buffer (Bufdelete, keep window layout)",
      },
    },
  },

  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    opts = {
      timeout = 300,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
        t = { k = { j = "<C-\\><C-n>" } },
      },
    },
  },
}

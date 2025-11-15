--[[-- Vim stuff related plugins

  - modes
  - motions
  - registers

--]]

---@type LazySpec
return {
  -- Better escape
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

  -- Navigation hints
  {
    "tris203/precognition.nvim",
    dependencies = { "chrisgrieser/nvim-spider" }, -- Spider aware precognition
    event = "VeryLazy",
    cmd = { "Precognition" },
    init = function()
      vim.keymap.set(
        "n",
        "<Leader>up",
        "<cmd>Precognition toggle<CR>",
        { desc = "Toggle navigation hints (Precognition)" }
      )
    end,
    opts = {
      startVisible = false,
      disable_fts = require("utils").disabled_filetypes,
    },
    config = function(_, opts) require("precognition").setup(opts) end,
  },

  -- Move like a spider: `camelCase` & `SNAKE_CASE` aware and skip unsignifiant punctuation
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        function() require("spider").motion("w") end,
        desc = "Spider-w",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        function() require("spider").motion("e") end,
        desc = "Spider-e",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        function() require("spider").motion("b") end,
        desc = "Spider-b",
        mode = { "n", "o", "x" },
      },
      {
        "ge",
        function() require("spider").motion("ge") end,
        desc = "Spider-ge",
        mode = { "n", "o", "x" },
      },
    },
    opts = {
      skipInsignificantPunctuation = false,
    },
  },

  -- Yanklock
  -- TODO: replace by `yanky` for more features
  {
    "daltongd/yanklock.nvim",
    opts = {
      notify = true,
    },
    keys = {
      {
        "<Leader>yl",
        function() require("yanklock").toggle() end,
      },
    },
  },

  -- Hardtime
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disabled_filetypes = require("utils").disabled_filetypes,
      disable_mouse = false,
      max_counts = 5,
    },
  },
}

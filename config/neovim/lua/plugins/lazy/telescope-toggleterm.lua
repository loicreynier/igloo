return {
  "da-moon/telescope-toggleterm.nvim",
  dependencies = {
    { "akinsho/toggleterm.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
  event = "TermOpen",
  keys = {
    {
      "<Leader>sT",
      "<Cmd>Telescope toggleterm<CR>",
      desc = "Search Terminals (Telescope/ToggleTerm)",
    },
  },
  opts = function()
    local actions = require("telescope.actions")
    opts = {
      telescope_mappings = {
        -- ["<C-c>"] = require("telescope-toggleterm").actions.exit_terminal,
        ["<C-c>"] = actions.close, -- Insert mode close
      },
    }
    -- return { extensions = { toggleterm = opts } }
    return opts
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    require("telescope-toggleterm").setup(opts)
    -- NOTE: Loading options from Telscope doesn't work
    -- Calling Telescope's setup from multiple specs does not hurt, it will merge for us
    -- telescope.setup(opts)
    telescope.load_extension("toggleterm")
  end,
}

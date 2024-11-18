local has_delta = vim.fn.executable("delta") == 1

return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "stevearc/dressing.nvim" },
      },
    },
  },
  keys = {
    {
      "<Leader>su",
      "<Cmd>Telescope undo<CR>",
      desc = "Search undo history (Telescope)",
    },
  },
  opts = function()
    local opts

    if has_delta then
      opts = {
        use_delta = true,
        side_by_side = true,
        layout_strategy = "vertical",
        layout_config = {
          preview_height = 0.8,
        },
      }
    else
      opts = {
        use_delta = false
      }
    end
    return { extensions = { undo = opts } }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    -- Calling Telescope's setup from multiple specs does not hurt, it will merge for us
    telescope.setup(opts)
    telescope.load_extension("undo")
  end,
}

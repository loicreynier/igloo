return {
  "MrcJkb/telescope-manix",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "stevearc/dressing.nvim" },
      },
    },
  },
  enabled = require("system").is_nix,
  keys = {
    {
      "<Leader>sn",
      "<Cmd>Telescope manix<CR>",
      desc = "Search Nix (Telescope Manix)",
    },
  },
  opts = {},
  config = function() -- function(_, opts)
    local telescope = require("telescope")
    -- Calling Telescope's setup from multiple specs does not hurt, it will merge for us
    -- telescope.setup(opts)
    telescope.load_extension("manix")
  end,
}

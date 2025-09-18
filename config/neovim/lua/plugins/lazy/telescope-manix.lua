return {
  "MrcJkb/telescope-manix",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
    },
  },
  enabled = require("system").is_nix,
  keys = {
    {
      "<Leader>sN",
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

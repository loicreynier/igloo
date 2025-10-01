---@type LazySpec
local spec = {}

if require("system").is_nix then spec = {
  "MrcJkb/telescope-manix",
  dependencies = {
    {
      "nvim-telescope/telescope.nvim",
    },
  },
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
end

return spec

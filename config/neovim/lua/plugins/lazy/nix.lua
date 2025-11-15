---@type LazySpec
return require("system").is_nix
    and {
      {
        "figsoda/nix-develop.nvim",
        cmd = { "NixDevelop", "NixShell" },
        config = function() end,
      },
      {
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
          -- telescope.setup(opts)
          telescope.load_extension("manix")
        end,
      },
      {
        "symphorien/vim-nixhash",
        cmd = "NixHash",
        opts = {},
      },
    }
  or {}

--[[-- Colorschemes

  TODO: add a better selection mechanism

  Plugins are loaded with

    lazy = false
    priority = 1000

  to make sure they are loaded during startup we want them available asap.
--]]

local priority_ = 1000
local install_all = not require("system").is_hpcc
local spec

local themes = {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = priority_,
    opts = {
      transparent = true,
      italic_inlayhints = true,
    },
  },

  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = priority_,
    config = function() end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = priority_,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = priority_,
    opts = {
      flavour = "auto",
      transparent_background = false,
      integrations = { blink_cmp = true },
    },
  },

  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = priority_,
    opts = {},
  },

  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = priority_,
    opts = {
      transparent = false,
      theme = "zen",
    },
  },

  {
    "mcauley-penney/techbase.nvim",
    lazy = false,
    priority = priority_,
    opts = {
      transparent = false,
      italic_comments = false,
      plugin_support = {
        blink = true,
        gitsigns = true,
        lazy = true,
        mason = true,
        visual_whitespace = true,
      },
    },
  },

  {
    "aktersnurra/no-clown-fiesta.nvim",
    lazy = false,
    priority = priority_,
    opts = {
      transparent = false,
    },
  },

  -- TODO: configure on GNOME only
  -- {
  --   "itsfernn/auto-gnome-theme.nvim",
  --   lazy = false,
  --   opts = {
  --     dark_theme = "github_dark",
  --     light_theme = "github_light",
  --   },
  -- },
}

if install_all then
  spec = themes
else
  spec = { themes[1] }
end

return spec

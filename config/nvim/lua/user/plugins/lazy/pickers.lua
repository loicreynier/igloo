local sinfo = vim.g.sinfo
local icons = require("user.rice").icons

---@type LazySpec[]
return {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "prochri/telescope-all-recent.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        opts = { database = { folder = vim.fn.stdpath("state") } },
      },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          history = {
            path = vim.fn.stdpath("state") .. "/telescope_history",
          },
          prompt_prefix = icons.prompt.prefix,
          selection_caret = icons.prompt.selection,
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          mappings = {
            i = {
              ["jj"] = { "<Esc>", type = "command" },
              ["<C-y>"] = actions.select_default,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-u>"] = false, -- Clear prompt instead of scroll the preview
              ["<M-u>"] = actions.preview_scrolling_up,
              ["<M-d>"] = actions.preview_scrolling_down,
            },
          },
        },
        pickers = {
          buffers = {
            sort_mrue = true,
            sort_lastused = true,
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("user.plugins.config.telescope.insert-buffer-name").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "polirritmico/telescope-lazy-plugins.nvim" },
    opts = {
      extensions = {
        lazy_plugins = { lazy_config = vim.fn.stdpath("config") .. "/lua/config/lazy.lua" },
      },
    },
  },

  -- FFF
  {
    "dmtrKovalenko/fff.nvim",
    build = function() require("fff.download").download_or_build_binary() end,
    lazy = false, -- Initializes itself lazyly
    version = "*",
    opts = {
      history = {
        enabled = true,
        db_path = vim.fn.stdpath("state") .. "/fff_queries",
      },
      layout = {
        prompt_position = "top",
      },
      prompt = icons.prompt.prefix,
      keymaps = {
        close = { "<C-c>" },
        preview_scroll_up = { "<A-u>" },
        preview_scroll_down = { "<A-d>" },
      },
    },
  },

  -- Papis
  {
    "jghauser/papis.nvim",
    enabled = not sinfo.is_hpcc,
    lazy = false, -- Initializes itself lazyly on `init_filetypes`
    dependencies = {
      "kkharji/sqlite.lua",
      "MunifTanjim/nui.nvim",
    },
    ---@module "papis"
    ---@type PapisConfigDefault
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      init_filetypes = { "markdown", "tex", "typst", "yaml" },
      enable_keymaps = false,
    },
  },
}

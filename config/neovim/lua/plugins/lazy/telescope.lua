--[[-- Telescope

  "Gaze deeply into unknown regions using the power of the moon"

  Telescope's LSP related action keymaps are defined in `config.keymaps`

--]]

return {
  -- Telescope itself
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    specs = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    cmd = "Telescope",
    keys = {
      -- "Main" actions
      {
        "<C-p>",
        "<Cmd>Telescope find_files<CR>",
        desc = "Find files (Telescope)",
      },
      {
        "<C-M-p>",
        "<Cmd>Telescope<CR>",
        desc = "Telescope prompt",
      },
      {
        "<Leader><Leader>",
        "<Cmd>Telescope buffers<CR>",
        desc = "Switch buffer (Telescope)",
      },
      {
        "<Leader>:",
        "<Cmd>Telescope command_history<CR>",
        desc = "Command History (Telescope)",
      },
      {
        "<Leader>/",
        "<Cmd>Telescope live_grep<CR>",
        desc = "Live grep (Telescope)",
      },
      -- "Find" actions
      {
        "<Leader>fb",
        "<Cmd>Telescope buffers<CR>",
        desc = "Switch buffer (Telescope)",
      },
      {
        "<Leader>ff",
        "<Cmd>Telescope find_files<CR>",
        desc = "Find files (Telescope)",
      },
      {
        "<Leader>fr",
        "<Cmd>Telescope oldfiles<CR>",
        desc = "Find recent files (Telescope)",
      },
      {
        "<Leader>fg",
        "<Cmd>Telescope git_files<CR>",
        desc = "Find Git files (Telescope)",
      },
      {
        "<Leader>fk",
        "<Cmd>Telescope keymaps<CR>",
        desc = "Find keymaps (Telescope)",
      },
      -- "Search" actions
      {
        "<Leader>sk",
        "<Cmd>Telescope keymaps<CR>",
        desc = "Search keymaps (Telescope)",
      },
      {
        "<Leader>sm",
        "<Cmd>Telescope man_pages<CR>",
        desc = "Search man pages (Telescope)",
      },
      {
        "<Leader>so",
        "<Cmd>Telescope vim_options<CR>",
        desc = "Search Vim options (Telescope)",
      },
      {
        "<Leader>sh",
        "<Cmd>Telescope help_tags<CR>",
        desc = "Search help tags (Telescope)",
      },
      {
        "<Leader>sH",
        "<Cmd>Telescope highlights<CR>",
        desc = "Search highlights groups (Telescope)",
      },
      {
        "<Leader>sd",
        "<Cmd>Telescope diagnostics<CR>",
        desc = "Search workspace diagnostics (Telescope)",
      },
      {
        "<Leader>sD",
        "<Cmd>Telescope diagnostics bufnr=0<CR>",
        desc = "Search buffer diagnostics (Telescope)",
      },
      {
        "<Leader>sq",
        "<Cmd>Telescope quickfix<CR>",
        desc = "Search quickfix items (Telescope)",
      },
      {
        "<Leader>sl",
        "<Cmd>Telescope loclist<CR>",
        desc = "Search location list (Telescope)",
      },
      {
        "<Leader>sw",
        function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") }) end,
        desc = "Search current word (<cword>) under cursor (Telescope)",
      },
      {
        "<Leader>sW",
        function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cWORD>") }) end,
        desc = "Search current word (<cWORD>) under cursor (Telescope)",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local themes = require("telescope.themes")
      local os_sep = require("plenary.path").path.sep
      local icons = require("rice").icons

      return {
        defaults = {
          prompt_prefix = icons.prompt.prefix,
          selection_caret = icons.prompt.selection,
          mappings = {
            i = {
              ["jj"] = { "<Esc>", type = "command" },
              ["jk"] = { "<Esc>", type = "coprevmmand" },
              ["<C-y>"] = actions.select_default,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-u>"] = false, -- Clear prompt instead of scroll the preview
              ["<M-u>"] = actions.preview_scrolling_up,
              ["<M-d>"] = actions.preview_scrolling_down,
            },
          },
          history = {
            path = vim.fn.stdpath("state") .. os_sep .. "telescope_history",
          },
        },
        pickers = {
          buffers = {
            sort_mru = true,
            sort_lastused = true,
          },
        },
        extensions = {
          fzf = {},
          ["ui-select"] = {
            themes.get_dropdown(),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")

      if vim.fn.executable("rg") == 0 then
        vim.notify(
          "Cannot find ripgrep executable, live grepping may not work",
          ---@diagnostic disable-next-line: param-type-mismatch
          "warn",
          { title = "Telescope setup" }
        )
      end

      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      -- FIXME: doesn't work in Lazy's `keys` spec on `ONERA_workstation` -> requires Telescope to be loaded first
      vim.keymap.set(
        "n",
        "<Leader>/",
        require("plugins.config.telescope.live-rg-glob"),
        { desc = "Live grep (Telescope)" }
      )

      vim.api.nvim_create_user_command(
        "InsertBufferName",
        require("plugins.config.telescope.insert-buffer-name"),
        { bang = true }
      )
    end,
  },

  -- (F)recency sorting for all pickers
  {
    "prochri/telescope-all-recent.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      {
        "kkharji/sqlite.lua",
        config = function()
          if require("system").is_nix and os.getenv("NVIM_NIX_SQLITE_PATH") then
            vim.g.sqlite_clib_path = os.getenv("NVIM_NIX_SQLITE_PATH")
          end
        end,
      },
    },
    opts = {
      database = {
        folder = vim.fn.stdpath("state"),
      },
    },
  },

  -- Zoxid-ing from Telescope
  {
    "jvgrootveld/telescope-zoxide",
    enabled = vim.fn.executable("zoxide") == 1,
    dependencies = { "nvim-lua/popup.nvim" },
    keys = {
      { "<Leader>fz", "<Cmd>Telescope zoxide list<CR>", desc = "Find Zoxide path (Telescope)" },
    },
    opts = function()
      local opts
      opts = {
        prompt_title = "Zoxide (<C-f> to pick file from path)",
        mappings = {
          ["<C-f>"] = {
            keepinsert = true,
            action = function(selection) require("telescope.builtin").find_files({ cwd = selection.path }) end,
          },
        },
      }
      return { extensions = { zoxide = opts } }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("zoxide")
    end,
  },

  -- Undo tree picker
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {},
    keys = {
      {
        "<Leader>su",
        "<Cmd>Telescope undo<CR>",
        desc = "Search undo history (Telescope)",
      },
    },
    opts = function()
      local opts

      if vim.fn.executable("delta") == 1 then
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
          use_delta = false,
        }
      end
      return { extensions = { undo = opts } }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("undo")
    end,
  },

  -- Lazy plugins picker
  {
    "polirritmico/telescope-lazy-plugins.nvim",
    keys = {
      { "<Leader>sL", "<Cmd>Telescope lazy_plugins<CR>", desc = "Search Lazy plugins specs (Telescope)" },
    },
    opts = function()
      local opts
      ---@module "telescope._extensions.lazy_plugins"
      ---@type TelescopeLazyPluginsUserConfig
      opts = {
        lazy_config = vim.fn.stdpath("config") .. "/lua/config/lazy.lua",
      }
      return { extensions = { lazy_plugins = opts } }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("lazy_plugins")
    end,
  },
}

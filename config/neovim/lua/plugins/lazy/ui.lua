---@type LazySpec
return {
  -- Notify
  -- TODO: replace by `snacks.notifier`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<Leader>un",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss all notifications (Notify)",
      },
    },
    opts = {
      stages = "static",
      timeout = 3000,
      background_colour = "#000000",
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
    },
  },

  -- Noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      { "rcarriga/nvim-notify" },
      { "MunifTanjim/nui.nvim", lazy = true },
    },
    keys = {
      { "<Leader>sn", "<Cmd>Noice telescope<CR>", desc = "Search Noice notifications (Telescope)" },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      require("noice").setup(opts)
      telescope.load_extension("noice")
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- Set an empty statusline till it loads
        vim.o.statusline = " "
      else
        -- Hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: "we don't need this `lualine` require madness" - LazyVim
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local opts = {
        options = {
          theme = "auto",
          disabled_filetypes = {
            statusline = require("utils").disabled_filetypes,
          },
        },
        sections = {
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            -- Word count for text, Markdown and TeX
            {
              function()
                if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
                  return vim.fn.wordcount().visual_words .. " words"
                else
                  return vim.fn.wordcount().words .. " words"
                end
              end,
              cond = function() return vim.tbl_contains({ "text", "markdown", "tex" }, vim.bo.filetype) end,
            },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }

      return opts
    end,
  },

  -- IDE breadcrumbs
  {
    "Bekaboo/dropbar.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = function()
      local menu_utils = require("dropbar.utils.menu")

      return {
        menu = {
          preview = false,
          keymaps = {
            ["<C-p>"] = "k",
            -- Back to parent menu
            ["h"] = "<C-w>q",
            -- Expands the menu if possible
            ["l"] = function()
              local menu = menu_utils.get_current()
              if not menu then return end
              local row = vim.api.nvim_win_get_cursor(menu.win)[1]
              local comp = menu.entries[row]:first_clickable()
              if comp then menu:click_on(comp, nil, 1, "l") end
            end,
          },
        },
      }
    end,
    config = function(_, opts)
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

      require("dropbar").setup(opts)
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    enabled = false,
    keys = {
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Switch to previous buffer (BufferLine)" },
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Switch to next buffer (BufferLine)" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer previous (BufferLine)" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next (BufferLine)" },
      { "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle buffer pin (BufferLine)" },
      { "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers (BufferLine)" },
      { "<Leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers (BufferLine)" },
      { "<Leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right (BufferLine)" },
      { "<Leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left (BufferLine)" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        -- Don't get too fancy as this function will be executed a lot
        diagnostics_indicator = function(_, _, diag)
          local icons = require("rice").icons.diagnostics
          local code = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(code)
        end,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "center",
          },
          {
            filetype = "DiffviewFiles",
            text = "Source Control",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            ---@diagnostic disable-next-line: undefined-global
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- Dashboard,
  {
    "folke/snacks.nvim",
    opts = { dashboard = vim.tbl_deep_extend("force", require("plugins.config.snacks.dashboard"), { enabled = true }) },
  },

  -- Flash cursor when jumping
  {
    "DanilaMihailov/beacon.nvim",
    enabled = not require("system").is_slow,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      cursor_events = { "CursorMoved" },
      window_events = { "WinEnter", "FocusGained" },
    },
  },

  -- Buffer sticks
  {
    "ahkohd/buffer-sticks.nvim",
    event = "VeryLazy",
    config = function()
      local sticks = require("buffer-sticks")
      sticks.setup({
        filter = { buftypes = { "terminal" } },
        highlights = {
          active = { link = "Statement" },
          alternate = { link = "StorageClass" },
          inactive = { link = "Whitespace" },
          active_modified = { link = "Constant" },
          alternate_modified = { link = "Constant" },
          inactive_modified = { link = "Constant" },
          label = { link = "Comment" },
        },
      })

      Snacks.toggle.new({
        id = "buffer_sticks",
        name = "Toggle buffer sticks",
        get = function() return sticks.is_visible() end,
        set = function() return sticks.toggle() end,
      })

      vim.api.nvim_create_user_command(
        "BufferSticksToggle",
        ---@diagnostic disable-next-line: undefined-field
        function() Snacks.toggle.toggles.buffer_sticks:toggle() end,
        {}
      )
    end,
  },

  -- Helpview: fancier help reader
  {
    "OXY2DEV/helpview.nvim",
    enabled = false,
    lazy = false, -- Helpview handles lazy loading
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}

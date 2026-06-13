local icons = require("user.rice").icons
local sinfo = vim.g.sinfo

---@module "lazy.types"
---@type LazySpec[]
return {
  -- Noice UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
    },
    ---@module "noice"
    ---@type NoiceConfig
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true, silent = true },
        signature = { enabled = true, auto_open = { enabled = false } },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    config = function(_, opts) require("noice").setup(opts) end,
  },

  -- Tiny CmdLine
  {
    "rachartier/tiny-cmdline.nvim",
    lazy = false,
    enabled = false,
    config = function()
      local tiny_cmdline = require("tiny-cmdline")
      tiny_cmdline.setup({
        on_reposition = tiny_cmdline.adapters.blink(),
      })
    end,
  },

  -- Keymaps help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@module "which-key"
    ---@type wk.Opts
    opts = {
      preset = "helix",
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        {
          "<Leader>c",
          mode = { "n" },
          group = "LSP",
          icon = icons.context.code,
        },
        {
          "<Leader>g",
          mode = { "n", "v" },
          group = "Git",
          icon = icons.git.logo,
        },
      })
    end,
    keys = {
      {
        "<Leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Show Buffer Local Keymaps (WhichKey)",
      },
    },
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

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = (vim.env.SYSTEM_THEME == "vscode" and "vscode") or "auto",
          disabled_filetypes = {
            statusline = { "dashboard", "snacks_dashboard" },
          },
          globalstatus = vim.o.laststatus == 3,
        },
        sections = {
          lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end } },
          lualine_b = {
            "branch",
            "diff",
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              separator = "",
            },
          },
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            { "filename", padding = { left = 0, right = 1 } },
            { "encoding", separator = "", padding = { left = 1, right = 0 } },
            { "fileformat" },
          },
          lualine_x = {
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function()
                if Snacks then return { fg = Snacks.util.color("Statement") } end
              end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function()
                if Snacks then return { fg = Snacks.util.color("Special") } end
              end,
            },
          },
          lualine_y = {
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
            { "progress", separator = "", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 1, right = 1 } },
          },
          lualine_z = {
            function() return " " .. os.date("%R") end,
          },
        },
        extensions = { "lazy" },
      }
      return opts
    end,
  },

  -- Embed status line in Tmux
  {
    "vimpostor/vim-tpipeline",
    dependencies = { "nvim-lualine/lualine.nvim" },
    enabled = false,
    event = "VeryLazy",
    cond = function() return vim.env.TMUX ~= nil end,
  },

  -- IDE breadcrumbs
  {
    "Bekaboo/dropbar.nvim",
    event = { "LspAttach" },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    keys = {
      {
        "<Leader>;",
        function() require("dropbar.api").pick() end,
        desc = "Pick symbols in winbar (Dropbar)",
      },
      {
        "];",
        function() require("dropbar.api").select_next_context() end,
        desc = "Select next context (Dropbar)",
      },
      {
        "[;",
        function() require("dropbar.api").goto_context_start() end,
        desc = "Go to start of current context (Dropbar)",
      },
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
  },

  -- Flash cursor when jumping
  {
    -- "DanilaMihailov/beacon.nvim",
    "shettysach/beacon.nvim", -- Fork with `border = 'none'` in `nvim_open_win`
    enabled = not sinfo.is_slow,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      cursor_events = { "CursorMoved" },
      window_events = { "WinEnter", "FocusGained" },
    },
  },
}

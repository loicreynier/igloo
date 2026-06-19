local sinfo = vim.g.sinfo
local auto_show = not sinfo.is_slow
local schedule_very_lazy = require("user.utils.lazy").schedule_very_lazy
local use_mini_snippets = false

---@module "lazy.types"
---@type LazySpec[]
return {
  -- Snippets engine/manager
  --
  -- Necessary for handling more complex snippets such as nested variables: `${4:raise $3}`
  --                                                                                   ^ nested
  {
    "nvim-mini/mini.snippets",
    enabled = use_mini_snippets,
    config = function()
      local gen_loader = require("mini.snippets").gen_loader
      require("mini.snippets").setup({
        mappings = {
          expand = "",
        },
        snippets = {
          -- gen_loader.from_file(vim.fn.stdpath("config") .. "snippets/global.json"),
          gen_loader.from_lang(),
        },
      })
    end,
  },

  -- Completion engine
  {
    "saghen/blink.cmp",
    enabled = vim.g.cmp_engine == "blink",
    lazy = false, -- Handles lazy loading internally
    -- event = { "InsertEnter", "CmdLineEnter" },
    version = "1.*", -- Use released tag to download pre-built binaries
    dependencies = {
      { "mini.snippets" } and use_mini_snippets or {},
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "mini_snippets" } and use_mini_snippets or {},
      sources = {
        default = {
          "lsp",
          "buffer",
          "path",
          "snippets",
        },
      },
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        -- ["<C-x>"] = { function(cmp) cmp.show({ providers = { "lsp" } }) end, "fallback" },
        -- ["<CR>"] = { "accept", "fallback" },
        ["<A-u>"] = { "scroll_documentation_up", "fallback" },
        ["<A-d>"] = { "scroll_documentation_down", "fallback" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      completion = {
        list = {
          max_items = 200,
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "none",
          auto_show = auto_show,
          auto_show_delay_ms = 0,
          draw = {
            treesitter = { "lsp" },
          },
          scrollbar = false, -- TODO: improve scrollbar placement within Noice commande line popup menu
        },
        ghost_text = {
          enabled = auto_show,
        },
        documentation = {
          auto_show = false,
          auto_show_delay_ms = 200,
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = { menu = { auto_show = false } },
      },
      signature = {
        enabled = false,
        window = {
          show_documentation = true,
          direction_priority = { "n", "s" },
          scrollbar = true,
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true, -- Sets the fallback highlights groups to nvim-cmp's highlight groups
        nerd_font_variant = "mono",
      },
    },
    opts_extend = {
      "sources.default",
    },
    init = function()
      schedule_very_lazy(function()
        if package.loaded["noice"] then require("user.plugins.config.blink.cmdline.noice-ui").setup() end
      end)
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "folke/lazydev.nvim" },
    opts = {
      sources = {
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "bydlw98/blink-cmp-env" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "env" },
        providers = {
          env = {
            name = "Env",
            module = "blink-cmp-env",
            opts = {
              show_braces = false, -- "$PATH" --> "${PATH}" if true
              show_documentation_window = true, -- Show window with variable value
            },
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "joelazar/blink-calc" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "calc" },
        providers = {
          calc = {
            name = "Calc",
            module = "blink-calc",
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "moyiz/blink-emoji.nvim" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "emoji" },
        providers = {
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            opts = {
              insert = true,
              ---@type string|table|fun():table
              trigger = function() return { ":" } end,
            },
            should_show_items = function() return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype) end,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "xieyonn/blink-cmp-dat-word" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "datword" },
        providers = {
          datword = {
            name = "Word",
            module = "blink-cmp-dat-word",
            score_offset = -100,
            opts = {
              paths = vim.fn.filereadable(os.getenv("WORDLIST") or "/usr/share/dict/word") == 1 and {
                -- See NixOS `environment.wordlist` module
                os.getenv("WORDLIST") or "/usr/share/dict/word",
              } or {},
            },
          },
        },
      },
    },
  },
}

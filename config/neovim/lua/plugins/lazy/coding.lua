--[[ Completion related plugins --]]

---@type LazySpec
return {
  -- Completion engine
  {
    "saghen/blink.cmp",
    event = { "InsertEnter" }, --  Add "CmdLineEnter" when enabling command line completion
    version = "1.*", -- Use released tag to download pre-built binaries
    dependencies = {
      { "saghen/blink.compat", version = "2.*", lazy = true, opts = {} },
      { "bydlw98/blink-cmp-env" },
      { "moyiz/blink-emoji.nvim" },
      { "rafamadriz/friendly-snippets" },
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<C-u>"] = { "scroll_signature_up", "fallback" },
        ["<C-d>"] = { "scroll_signature_down", "fallback" },
        ["<C-k>"] = { "show_signature", "fallback" },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      signature = {
        enabled = true,
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "env",
          "emoji",
        },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- Make LazyDev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          env = {
            name = "Env",
            module = "blink-cmp-env",
            opts = {
              show_braces = false, -- "$PATH" --> "${PATH}" if true
              show_documentation_window = true, -- Show window with variable value
            },
          },
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
      cmdline = {
        enabled = false,
        keymap = { preset = "cmdline" },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(_) return vim.fn.getcmdtype() == ":" end,
          },
          ghost_text = { enabled = true },
        },
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono", -- TODO: add selection mechanism?
        kind_icons = require("rice").icons.kinds,
      },
    },
  },
}

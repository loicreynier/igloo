---@type LazySpec
return {
  "saghen/blink.cmp",
  enabled = true,
  version = "1.4.1", -- Use released tag to download pre-built binaries
  dependencies = {
    { "saghen/blink.compat", version = "2.*", lazy = true, opts = {} },
    { "rafamadriz/friendly-snippets" },
  },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    -- (Default) Only show documentation popup when manual triggered
    completion = { documentation = { auto_show = false } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    sources = {
      default = {
        "lazydev",
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- Make LazyDev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
    appearance = {
      kind_icons = require("rice").icons.kinds,
    },
  },
}

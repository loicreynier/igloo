-- TODO: install Blink, only the LazyDev options have been set up

return {
  "saghen/blink.cmp",
  enabled = false,
  opts = {
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
  },
}

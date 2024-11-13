return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true, opts = { enable_autocmd = false } } },
  },
  keys = {
    { "gc", mode = "v" },
    { "gb", mode = "v" },
    { "gcc" },
    { "gbc" },
    { "gco" },
    { "gcO" },
    { "gcA" },
  },
  config = function()
    require("Comment").setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })
  end,
}

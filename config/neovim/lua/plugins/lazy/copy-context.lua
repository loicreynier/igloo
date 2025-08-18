return {
  "zhisme/copy_with_context.nvim",
  keys = {
    {
      "<Leader>cy",
      function() require("copy_with_context.main").copy_with_context(true, true) end,
      desc = "Copy with context",
    },
    {
      "<Leader>cY",
      function() require("copy_with_context.main").copy_with_context(false, true) end,
      desc = "Copy with context (relative)",
    },
  },
  opts = {},
}

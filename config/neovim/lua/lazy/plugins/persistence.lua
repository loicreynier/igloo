return {
  "folke/persistence.nvim",
  enabled = false, -- Use `persistence.nvim` instead of `persisted.nvim` on low performance rigs?
  event = "BufReadPre",
  keys = {
    {
      "<Leader>ql",
      function()require('persistence').load() end,
      desc = "Load session (Persistence)",
    },
    {
      "<Leader>qs",
      function()require('persistence').save() end,
      desc = "Save session (Persistence)",
    },
    {
      "<Leader>qS",
      function()require('persistence').select() end,
      desc = "Select session (Persistence)",
    },
  },
  opts = {},
}

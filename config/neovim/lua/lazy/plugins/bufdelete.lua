return {
  "famiu/bufdelete.nvim",
  keys = {
    {
      "<Leader>bD",
      function() require("bufdelete").bufdelete(0, false) end,
      desc = "Delete current buffer (Bufdelete, keep window layout)",
    },
  },
}

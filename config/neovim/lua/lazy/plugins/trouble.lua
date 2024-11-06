return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {},
  keys = {
    {
      "<Leader>xx",
      "<Cmd>Trouble diagnostics toggle<CR>",
      desc = "Toggle diagnostics panel (Trouble)",
    },
    {
      "<Leader>xX",
      "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Toggle buffer diagnostics panel (Trouble)",
    },
    {
      "<Leader>xq",
      "<Cmd>Trouble qflist toggle<CR>",
      desc = "Toggle quickfix panel (Trouble)",
    },
    {
      "<Leader>xl",
      "<Cmd>Trouble loclist toggle<CR>",
      desc = "Toggle location list panel (Trouble)",
    },
    {
      "<Leader>cs",
      "<Cmd>Trouble symbols toggle<CR>",
      desc = "Toggle document symbols panel (Trouble)",
    },
    {
      "<Leader>cS",
      "<Cmd>Trouble lsp toggle<CR>",
      desc = "Toggle LSP references/definitions/... panel (Trouble)",
    },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = "Previous Trouble/Quickfix item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = "Next Trouble/Quickfix item",
    },
  },
}

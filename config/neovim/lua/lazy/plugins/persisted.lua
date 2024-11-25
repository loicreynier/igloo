return {
  "olimorris/persisted.nvim",
  event = "BufReadPre",
  keys = {
    {
      "<leader>ql",
      "<Cmd>SessionLoad<CR>",
      desc = "Load session (Persisted)",
    },
    {
      "<leader>qs",
      "<Cmd>SessionSave<CR>",
      desc = "Save session (Persisted)",
    },
    {
      "<leader>qS",
      function() require("telescope").extensions.persisted.persisted() end,
      desc = "Load session (Persisted)",
    },
    {
      "<leader>qt",
      "<Cmd>SessionToggle<CR>",
      desc = "Toggle sessions saving (Persisted)",
    },
  },
  opts = {
    autostart = true,
    autoload = false,
    use_git_branch = true,
    should_save = function()
      if vim.bo.filetype == "alpha" then return false end
      if vim.bo.filetype == "" and vim.api.nvim_buf_get_name(0) == "" then return false end
      if vim.api.nvim_buf_get_name(0):match("COMMIT_EDITMSG") then return false end
      return true
    end,
    telescope = {
      mappings = {
        copy_session = "<C-r>",
      },
    },
  },
  config = function(_, opts)
    require("persisted").setup(opts)
    require("telescope").load_extension("persisted")
  end,
}

return {
  "jvgrootveld/telescope-zoxide",
  enabled = vim.fn.executable("zoxide") == 1,
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  keys = {
    { "<Leader>fz", "<Cmd>Telescope zoxide list<CR>", desc = "Find Zoxide path (Telescope)" },
  },
  opts = function()
    local telescope = require("telescope")
    local opts
    opts = {
      prompt_title = "Zoxide (<C-f> to pick file from path)",
      mappings = {
        ["<C-f>"] = {
          keepinsert = true,
          action = function(selection) telescope.builtin.find_files({ cwd = selection.path }) end,
          desc = "Coucou",
        },
      },
    }
    return { extensions = { zoxide = opts } }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("zoxide")
  end,
}

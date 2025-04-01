---@type LazySpec
return {
  "prochri/telescope-all-recent.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
    "stevearc/dressing.nvim",
  },
  opts = {
    database = {
      folder = vim.fn.stdpath("state"),
    },
  },
}

--[[-- Colorschemes

  TODO: add a better selection mechanism

  Plugins are loaded with

    lazy = false
    priority = 1000

  to make sure they are loaded during startup we want them available asap.
--]]

return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
    },
    config = function() vim.cmd.colorscheme("vscode") end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- config = function() vim.cmd.colorscheme("tokyonight-night") end,
  },
}

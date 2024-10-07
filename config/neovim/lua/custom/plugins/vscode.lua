return {
  "Mofiqul/vscode.nvim",
  lazy = false, -- Load during startup since colorscheme
  priority = 1000, -- Make sure it is loaded first
  opts = {
    transparent = false,
  },
  config = function()
    vim.cmd.colorscheme "vscode"
  end,
}

return {
  { "vim-scripts/bbcode", ft = "bbcode" },
  { "manicmaniac/coconut.vim", ft = "coconut" },
  -- { "kaarmu/typst.vim", ft = "typst" },
  {
    "trapd00r/vim-syntax-vidir-ls",
    event = "BufEnter edir.sh",
    config = function() vim.cmd("set filetype=vidir-ls") end,
  },
}

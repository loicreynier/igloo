vim.filetype.add({
  extension = {
    bbcode = "bbcode",
    cuf = "fortran",
    dig = "fortran", -- DYJEAT input file
  },
  filename = {
    [".envrc"] = "sh",
    [".ecrc"] = "json",
    [".yamllint"] = "yaml",
  },
  pattern = {
    ["%.env%..*"] = "sh",
  }
})

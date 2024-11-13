vim.filetype.add({
  extension = {
    bbcode = "bbcode",
    cuf = "fortran",
    dig = "fortran", -- DYJEAT input file
  },
  filename = {
    ["edir.sh"] = nil,
    [".envrc"] = "sh",
    [".ecrc"] = "json",
    [".yamllint"] = "yaml",
    ["ns.inp"] = "fortran", -- POUSSINS input file
    ["Dyjeat.in"] = "fortran",
  },
  pattern = {
    ["%.env%..*"] = "sh",
  },
})

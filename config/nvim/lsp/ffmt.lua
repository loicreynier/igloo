---@type vim.lsp.Config
return {
  cmd = { "ffmt", "--lsp" },
  filetypes = { "fortran" },
  root_markers = {
    ".ffmt.toml",
    "ffmt.toml",
    "pyproject.toml",
  },
}

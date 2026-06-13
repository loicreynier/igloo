---@type vim.lsp.Config
return {
  cmd = { "fortitude", "server" },
  filetypes = { "fortran" },
  root_markers = {
    "fpm.toml",
    ".fortitude.toml",
    "fortitude.toml",
    ".git",
  },
}

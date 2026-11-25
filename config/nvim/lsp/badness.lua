---@type vim.lsp.Config
return {
  cmd = { "badness", "lsp" },
  filetypes = { "tex", "plaintex", "bib" },
  root_markers = { "badness.toml", ".git" },
}

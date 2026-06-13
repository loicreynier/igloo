---@type vim.lsp.Config
return {
  cmd = { "typos-lsp" },
  root_markers = {
    ".typos.toml",
    "_typos.toml",
    "typos.toml",
    ".git",
  },
  -- Disable on text files already handled by LTeX
  -- TODO: better handling?
  on_attach = function(client, _)
    local disabled_filetypes = vim.iter(vim.lsp.config["ltex"].filetypes)
    if disabled_filetypes:find(vim.bo.filetype) ~= nil then client:stop() end
  end,
}

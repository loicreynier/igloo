local language_id_mapping = {
  text = "plaintext",
  bib = "bibtex",
  plaintex = "tex",
  tex = "latex",
  rst = "restructuredtext",
  pandoc = "markdown",
  rnoweb = "rsweave",
}

local filetypes = {
  "bib",
  "gitcommit",
  "markdown",
  "org",
  "plaintex",
  "rst",
  "rnoweb",
  "tex",
  "pandoc",
  "quarto",
  "rmd",
  "context",
  "html",
  "xhtml",
  "mail",
  "text",
  "typst",
}

local function get_language_id(_, filetype)
  local language_id = language_id_mapping[filetype]
  if language_id then
    return language_id
  else
    return filetype
  end
end

local enabled_ids = {}

do
  local enabled_keys = {}
  for _, ft in ipairs(filetypes) do
    local id = get_language_id({}, ft)
    if not enabled_keys[id] then
      enabled_keys[id] = true
      table.insert(enabled_ids, id)
    end
  end
end

---@type vim.lsp.Config
return {
  cmd = { "ltex-ls-plus" },
  filetypes = filetypes,
  root_markers = {
    ".ltex",
    ".git",
  },
  get_language_id = get_language_id,
  settings = {
    ltex = {
      enabled = enabled_ids,
      checkFrequency = "save",
    },
  },
}

local M = {}

-- Return EditorConfig's `indent_size` or `size`
M.indent_size = function(size) return tonumber((vim.b[0].editorconfig or {}).indent_size) or size end

-- Return EditorConfig's `tab_width` or `width`
M.tab_width = function(width) return tonumber((vim.b[0].editorconfig or {}).tab_width) or width end

-- Return EditorConfig's `max_line_length` or `len`
M.text_width = function(width) return tonumber((vim.b[0].editorconfig or {}).max_line_length) or width end

-- Uneditable filetypes that should not be parsed by (most) plugins
M.disabled_filetypes = {
  "help",
  "checkhealth",
  "lspinfo",
  "lazy",
  "alpha",
  "noice",
  "Trouble",
  "neo-tree",
  "NvimTree",
}

-- Uneditable buffers that should not be parsed by (most) plugins
M.disabled_buftypes = {
  "help",
  "nofile",
  "terminal",
  "prompt",
}

return M

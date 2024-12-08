local M = {}

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

local M = {}

---Uneditable filetypes that should not be parsed by (most) plugins
---@type string[]
M.disabled_filetypes = {
  "help",
  "checkhealth",
  "lspinfo",
  "lazy",
  "snacks_dashboard",
}

---Uneditable buffers that should not be parsed by (most) plugins
---@type string[]
M.disabled_buftypes = {
  "help",
  "nofile",
  "terminal",
  "prompt",
}

return M

local M = {}

--[[-- EditorConfig getter functions ---------------------------------------------------------------------------------]]

---@alias editorconfig_getter fun(param: integer): number?

---Return EditorConfig's `indent_size` or `size`
---@type editorconfig_getter
M.indent_size = function(size) return tonumber((vim.b[0].editorconfig or {}).indent_size) or size end

---Return EditorConfig's `tab_width` or `width`
---@type editorconfig_getter
M.tab_width = function(width) return tonumber((vim.b[0].editorconfig or {}).tab_width) or width end

---Return EditorConfig's `max_line_length` or `len`
---@type editorconfig_getter
M.text_width = function(width) return tonumber((vim.b[0].editorconfig or {}).max_line_length) or width end

--[[-- Disabled filetypes --------------------------------------------------------------------------------------------]]

---Uneditable filetypes that should not be parsed by (most) plugins
---@type string[]
M.disabled_filetypes = {
  "help",
  "checkhealth",
  "lspinfo",
  "lazy",
  "alpha",
  "snacks_dashboard",
  "noice",
  "Trouble",
  "neo-tree",
  "NvimTree",
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

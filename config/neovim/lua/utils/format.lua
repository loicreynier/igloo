--[[-- Formatting utils

  Made to be used with Conform and Snacks.

  Code stolen and adapted from LazyVim.
  Source: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/format.lua

  LazyVim uses its own formatting mechanisms and functions.
  This simplified module provides:
  - `enable` (to be used by Conform) to check whether global/buffer autoformat is enabled
  - `snacks_toggle` to create Snacks toggles for global/buffer autoformat

--]]

local M = {}

---Enable global/buf autoformat
---@param enable? boolean
---@param buf? boolean
function M.enable(enable, buf)
  if enable == nil then enable = true end
  if buf then
    vim.b.autoformat = enable
  else
    vim.g.autoformat = enable
    vim.b.autoformat = nil
  end
end

---Whether global/buffer autoformat is enabled
---@param buf? number
function M.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then return baf end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param buf? boolean
function M.snacks_toggle(buf)
  return Snacks.toggle({
    name = "Autoformat (" .. (buf and "Buffer" or "Global") .. ")",
    get = function()
      if not buf then return vim.g.autoformat == nil or vim.g.autoformat end
      return M.enabled()
    end,
    set = function(state) M.enable(state, buf) end,
  })
end

return M

local M = {}

local very_lazy_fired = false

---Schedule `function` after `VeryLazy` event
---@param callback function
M.schedule_very_lazy = function(callback)
  if very_lazy_fired then
    vim.schedule(callback)
    return
  end
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function() callback() end,
  })
end

return M

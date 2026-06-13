local M = {}

---@type uv.uv_timer_t?
local timer = nil
---@type integer Delay in ms
local delay = 60000

local function debounced_save()
  local buf = vim.api.nvim_get_current_buf()

  if timer then
    timer:stop()
    timer:close()
  end

  timer = vim.uv.new_timer()
  ---@diagnostic disable-next-line: need-check-nil
  timer:start(delay, 0, function()
    ---@diagnostic disable-next-line: need-check-nil
    timer:close()
    timer = nil
    vim.schedule(function() M.save(buf) end)
  end)
end

---@param buf number?
function M.save(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  if not (vim.bo[buf].modified and vim.bo[buf].modifiable and vim.bo[buf].buftype == "") then return end

  if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_call(buf, function() vim.cmd("silent! write") end) end
  vim.api.nvim_echo({ { "Auto-save: save at " .. vim.fn.strftime("%H:%M:%S"), "MsgArea" } }, true, {})
end

function M.setup()
  vim.api.nvim_create_augroup("AutoSave", { clear = true })
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    callback = debounced_save,
    pattern = "*",
    group = "AutoSave",
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = "AutoSave",
    callback = function()
      if timer then
        timer:stop()
        timer:close()
        timer = nil
      end
    end,
  })
end

return M

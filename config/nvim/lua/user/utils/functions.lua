local M = {}

---Touch file from visual selected path
---@param skip_confirm boolean Whether to ask for confirmation
function M.touch_file_from_selection(skip_confirm)
  local notify_opts = { title = "TouchFile" }
  local _, ls, cs, _ = unpack(vim.fn.getpos("'<"))
  local _, le, ce, _ = unpack(vim.fn.getpos("'>"))

  local lines = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  local path = table.concat(lines, "\n"):match("^%s*(.-)%s*$") -- Trim leading/trailing whitespace

  if path == "" then
    vim.notify("No path selected", vim.log.levels.WARN, notify_opts)
    return
  end

  local full_path
  if path:sub(1, 1) == "/" then
    full_path = path
  else
    -- local base_dir = vim.fn.expand("%:p:h")
    local base_dir = vim.fn.getcwd()
    full_path = vim.fn.fnamemodify(base_dir .. "/" .. path, ":p")
  end

  if vim.fn.filereadable(full_path) == 1 then
    vim.notify("File already exists: " .. full_path, vim.log.levels.WARN, notify_opts)
    return
  end

  local function create_file()
    local parent_dir = vim.fn.fnamemodify(full_path, ":h")
    if vim.fn.isdirectory(parent_dir) == 0 then
      local ok = vim.fn.mkdir(parent_dir, "p")
      if ok == 0 then
        vim.notify("Failed to create directories: " .. parent_dir, vim.log.levels.ERROR, notify_opts)
        return
      end
    end

    local file = io.open(full_path, "w")
    if file then
      file:close()
      vim.notify("Created: " .. full_path, vim.log.levels.INFO, notify_opts)
    else
      vim.notify("Failed to create: " .. full_path, vim.log.levels.ERROR, notify_opts)
    end
  end

  if not skip_confirm then
    vim.ui.input({ prompt = "Create file '" .. path .. "'? [y/N] " }, function(confirm)
      if confirm and confirm:lower() == "y" then
        create_file()
      else
        vim.notify("Cancelled", vim.log.levels.INFO, notify_opts)
      end
    end)
  else
    create_file()
  end
end

return M

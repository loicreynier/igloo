local cmd = vim.api.nvim_create_user_command

cmd("Put", function(opts)
  ---@type string
  local res

  if opts.bang == true then
    local out = vim
      .system({
        vim.o.shell,
        vim.o.shellcmdflag,
        opts.args,
      }, {})
      :wait()
    if out.code ~= 0 then
      vim.notify("Command failed with exit code " .. out.code)
      return
    end
    res = out.stdout or ""
  else
    res = vim.fn.execute(opts.args)
  end
  local start_line, end_line
  if opts.range > 0 then
    start_line = opts.line1 - 1
    end_line = opts.line2 or start_line
  else
    start_line = vim.api.nvim_win_get_cursor(0)[1]
    end_line = start_line
  end
  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, vim.split(vim.fn.trim(res), "\n"))
end, {
  bang = true,
  range = true,
  nargs = "+",
  complete = "command",
  desc = "Put the result of a Vim or shell command into the current buffer",
})

cmd("RemoveComments", function(opts)
  local rm_comments = require("user.utils.treesitter").remove_comments
  if opts.bang then
    rm_comments()
  else
    vim.notify("Use: :RemoveComments! to confirm comment removal", vim.log.levels.INFO, { title = "RemoveComments" })
  end
end, { bang = true, desc = "Remove all comments using Treesitter" })

cmd("TouchFile", function(opts)
  -- Exit visual mode first to update `'< '>` marks
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  require("user.utils.functions").touch_file_from_selection(opts.bang)
end, { bang = true, range = true, desc = "Create file from visual selected path" })

cmd("Groot", function()
  local git_root = vim.fs.root(0, ".git")
  if not git_root then
    vim.notify("Not inside a Git repository", vim.log.levels.WARN, { title = "Groot" })
    return
  end
  vim.fn.chdir(git_root)
  vim.notify(git_root, vim.log.levels.INFO, { title = "Groot" })
end, { desc = "Change working directory to Git root" })

cmd("InsertNumbers", function(opts)
  -- Parse string of args
  local args = {}
  for arg in opts.args:gmatch("%S+") do
    table.insert(args, arg)
  end

  -- Parse padding: InsertNumbers 01 10 -> 01 02 .. 10
  local arg1_raw = args[1]
  local pad = arg1_raw and arg1_raw:match("^0%d") and #arg1_raw or nil

  local formatted_num = function(n)
    if pad then return string.format("%0" .. pad .. "d", n) end
    return tostring(n)
  end

  for i, v in ipairs(args) do
    args[i] = tonumber(v)
  end
  local start = args[1] or 1
  local step = args[2] or 1

  local start_row, end_row, col
  local is_visual = opts.range > 0

  if is_visual then
    start_row = vim.fn.line("'<")
    end_row = vim.fn.line("'>")
    col = vim.fn.col("'<") - 1
  else
    if not args[3] then
      vim.notify(
        "No line count provided. Usage: InsertNumbers [start] [step] [lines]",
        vim.log.levels.ERROR,
        { title = "InsertNumbers" }
      )
      return
    end
    local num_lines = args[3] or 1
    start_row = vim.fn.line(".")
    end_row = start_row + num_lines - 1
    col = vim.fn.col(".") - 1
  end

  local current = start

  for row = start_row, end_row do
    local line = vim.fn.getline(row)
    local new_line = line:sub(1, col) .. formatted_num(current) .. line:sub(col + 1)
    vim.fn.setline(row, new_line)
    current = current + step
  end

  if is_visual then vim.cmd("normal! gv") end

  vim.cmd("normal! gv")
end, { range = true, nargs = "*", desc = "Insert incrementally number sequence" })

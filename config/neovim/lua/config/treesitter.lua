local remove_comments = function()
  local ts = vim.treesitter
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local lang = ts.language.get_lang(ft) or ft
  local notify_opts = { title = "RemoveComments" }

  local ok, parser = pcall(ts.get_parser, bufnr, lang)
  if not ok or not parser then
    vim.notify("No parser for filetype: " .. ft, vim.log.levels.WARN, notify_opts)
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  local query = ts.query.parse(lang, "(comment) @comment")

  local ranges = {}
  for _, node in query:iter_captures(root, bufnr, 0, -1) do
    if node:type() == "comment" then table.insert(ranges, { node:range() }) end
  end

  if #ranges == 0 then
    vim.notify("No comments found", vim.log.levels.INFO, notify_opts)
    return
  end

  table.sort(ranges, function(a, b)
    if a[1] == b[1] then return a[2] < b[2] end
    return a[1] > b[1]
  end)

  for _, r in ipairs(ranges) do
    vim.api.nvim_buf_set_text(bufnr, r[1], r[2], r[3], r[4], {})
  end
end

vim.api.nvim_create_user_command("RemoveComments", function(opts)
  local notify_opts = { title = "RemoveComments" }

  if opts.bang then
    remove_comments()
  else
    vim.notify("Use :RemoveComments! to confirm comment removal", vim.log.levels.INFO, notify_opts)
  end
end, { bang = true })

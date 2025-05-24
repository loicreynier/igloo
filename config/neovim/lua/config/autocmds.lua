-- Create missing directories in path
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*" },
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if dir:find("%l+://") == 1 then return end

    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
  end,
})

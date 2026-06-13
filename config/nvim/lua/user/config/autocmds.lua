-- Create missing directories in path
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*" },
  callback = function()
    local filepath = vim.fn.expand("<afile>:p")

    -- Skip if path is a URL or already exists
    if filepath:find("%l+://") == 1 or vim.fn.filereadable(filepath) == 1 then return end

    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 1 then return end

    vim.ui.select({ "Yes", "No" }, {
      prompt = string.format("Directory '%s' doesn't exist. Create it?", dir),
      format_item = function(item) return item end,
    }, function(choice)
      if choice == "Yes" then vim.fn.mkdir(dir, "p") end
    end)
  end,
})

-- Auto reload config
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { vim.env.MYVIMRC, vim.fn.stdpath("config") .. "/lua/config/init.lua" },
  callback = function()
    vim.cmd("source " .. vim.env.MYVIMRC)
    vim.notify("Config reloaded!", vim.log.levels.INFO)
  end,
})

-- Highlight when yanking
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   group = vim.api.nvim_create_augroup("user.highlight-yank", { clear = true }),
--   callback = function() vim.highlight.on_yank() end,
-- })

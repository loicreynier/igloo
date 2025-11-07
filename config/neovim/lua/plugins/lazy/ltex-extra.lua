return {
  "barreiroleo/ltex_extra.nvim",
  branch = "dev",
  ft = { "markdown", "tex" },
  dependencies = { "neovim/nvim-lspconfig" },
  opts = function()
    local path_
    local git_root = vim.fs.dirname(vim.fs.find(".git", { path = vim.loop.cwd(), upward = true })[1])

    if git_root then
      if #vim.fn.glob(git_root .. "/.vscode" .. "/ltex.*", true, true) == 0 then
        path_ = git_root .. "/.ltex"
      else
        path_ = git_root .. "/.vscode"
      end
    else
      path_ = vim.fn.stdpath("data") .. "/ltex"
    end

    return {
      path = path_,
    }
  end,
}

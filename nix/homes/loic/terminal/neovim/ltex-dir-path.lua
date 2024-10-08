--[[ Function to setup LTeX config path

    If in a Git repo:
        - `/.vscode` if there are LTeX file in `.vscode` (VS Code extension compatibility)
        - `/.ltex` if not
    If not, `$HOME/.local/share/ltex`.

        require("ltex_extra").setup({path=ltex_dir_path()})
--]]

---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local function ltex_dir_path()
  local util = require("lspconfig.util")
  local path

  local git_root = util.find_git_ancestor(vim.loop.cwd())

  if git_root then
    if #vim.fn.glob(git_root .. "/.vscode" .. "/ltex.*", 1, 1) == 0 then
      path = git_root .. "/.ltex"
    else
      path = git_root .. "/.vscode"
    end
  else
    path = vim.fn.stdpath("data") .. "/ltex"
  end

  return path
end

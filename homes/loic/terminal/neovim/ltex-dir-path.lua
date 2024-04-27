--[[ Function to setup LTeX config path

    If in a Git repo, `.vscode` for compatibility with the VS Code extension.
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
        path = git_root .. "/.vscode"
    else
        path = vim.fn.stdpath("data") .. "/ltex"
    end

    return path
end

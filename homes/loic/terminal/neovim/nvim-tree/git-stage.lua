--[[ Git stage/unstage from the tree

    Source: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes

    Stage from the tree using `ga`
    (or another keybinding defined in `on_attach`).
--]]

local api = require("nvim-tree.api")

local git_add = function()
    local node = api.tree.get_node_under_cursor()
    local gs = node.git_status.file

    -- If the current node is a directory get children status
    if gs == nil then
        gs = (
            node.git_status.dir.direct ~= nil
            and node.git_status.dir.direct[1]
        )
            or (
                node.git_status.dir.indirect ~= nil
                and node.git_status.dir.indirect[1]
            )
    end

    -- If the file is untracked, unstaged or partially staged...
    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
        -- ... stage it
        vim.cmd("silent !git add " .. node.absolute_path)
    elseif gs == "M " or gs == "A " then
        -- ... else, unstage it
        vim.cmd("silent !git restore --staged " .. node.absolute_path)
    end

    api.tree.reload()
end

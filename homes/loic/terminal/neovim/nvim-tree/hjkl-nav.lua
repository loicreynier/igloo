--[[ h, j, k, l Style Navigation And Editing

    Source: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes

    Hotkeys that keep your fingers using `h`, `j`, `k`, `l`
    for naviation and opening:

    - `Ctrl` + `h`: open tree
    - `h`: collapse current containing folder
    - `H`: collapse tree
    - `l`: open node if it is a folder, else edit the file and close tree
    - `L`: open node if it is a folder, else create `vsplit`of file and
           keep cursor on tree

    In particular,
    `L` is nice for opening a few files in quick succession
    without losing focus of the three
    while `l` is used for editing just a file in the current buffer.
--]]

---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local api = require("nvim-tree.api")

-- Open and close tree
local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
        api.node.open.edit()
    else
        api.node.open.edit()
        api.tree.close()
    end
end

-- Open `vsplit` and keep focus on tree
local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
        api.node.open.edit()
    else
        api.node.open.vertical()
    end
    api.tree.focus()
end

vim.api.nvim_set_keymap(
    "n",
    "<C-h>",
    ":NvimTreeToggle<cr>",
    { silent = true, noremap = true }
)

--[[-- Neo-tree

  References:
  - https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins/neo-tree.lua

--]]

---@diagnostic disable: undefined-field
return {
  "nvim-neo-tree/neo-tree.nvim",
  -- Cannot hijack `netrw` if lazy loaded
  -- PERF: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1247
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "<Leader>fe",
      function() require("neo-tree.command").execute({ toggle = true }) end,
      desc = "Toggle file explorer (NeoTree)",
    },
    {
      "<Leader>fE",
      function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end,
      desc = "Toggle file explorer (NeoTree)",
    },
    {
      "<Leader>e",
      "<Leader>fe",
      desc = "Toggle file explorer (NeoTree)",
      remap = true,
    },
    {
      "<Leader>E",
      "<Leader>fE",
      desc = "Toggle file explorer (NeoTree)",
      remap = true,
    },
    {
      "<Leader>be",
      function()
        require("neo-tree.command").execute({
          source = "buffers",
          toggle = true,
        })
      end,
      desc = "Toggle buffer explorer (NeoTree)",
    },
    {
      "<Leader>ge",
      function()
        require("neo-tree.command").execute({
          source = "git_status",
          toggle = true,
        })
      end,
      desc = "Toggle Git explorer (NeoTree)",
    },
  },
  opts = {
    close_if_last_window = true,
    sources = {
      "filesystem",
      "buffers",
      "git_status",
    },
    source_selector = {
      winbar = true,
      content_layout = "center",
      ---@diagnostic disable-next-line: undefined-global
      sources = sources,
    },
    commands = {
      go_parent_or_close = function(state)
        local node = state.tree:get_node()
        if node:has_children() and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      go_child_or_open = function(state)
        local node = state.tree:get_node()
        if node:has_children() then
          if not node:is_expanded() then
            state.commands.toggle_node(state)
          else
            if node.type == "file" then
              state.commands.open(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          end
        else
          state.commands.open(state)
        end
      end,
    },
    window = {
      position = "left",
      mappings = {
        h = "go_parent_or_close",
        l = "go_child_or_open",
        x = "open_split",
        v = "open_vsplit",
        t = "open_tabnew",
        ["Backspace"] = "navigate_up",
        ["<C-h>"] = "navigate_up",
        [";"] = "set_root",
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
    },
  },
}

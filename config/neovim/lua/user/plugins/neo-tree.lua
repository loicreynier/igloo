-- References:
-- https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins/neo-tree.lua

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    cmd = "Neotree",

    keys = {
      {
        "<Leader>fe",
        function()
          require("neo-tree.command").execute({toggle = true})
        end,
        desc = "Toggle file explorer (NeoTree)",
      },
      { "<Leader>e", "<Leader>fe", desc = "Toggle file explorer (NeoTree)", remap = true },
      {
        "<Leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Toggle buffer explorer (NeoTree)",
      },
      {
        "<Leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
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
        position = "right",
        mappings = {
          h = "go_parent_or_close",
          l = "go_child_or_open",
        },
      },
    },
  },
}

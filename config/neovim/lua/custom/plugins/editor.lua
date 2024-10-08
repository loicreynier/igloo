--[[-- Editor plugins

  Plugins to transform Neovim into a featureful IDE:
  - `neo-tree`
  - `git-signs`
  - `trouble`
  - `todo-comments`
  - `toggleterm.nvim`

  References:
  - https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins/neo-tree.lua

--]]

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
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "Toggle file explorer (NeoTree)",
      },
      {
        "<Leader>e",
        "<Leader>fe",
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
        sources = sources,
      },
      commands = {
        go_parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(
              state,
              node:get_parent_id()
            )
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
                require("neo-tree.ui.renderer").focus_node(
                  state,
                  node:get_child_ids()[1]
                )
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

  {
    "ewis6991/gitsigns.nvim",
    opts = {},
    -- TODO: add keys for Git actions
  },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
    keys = {
      {
        "<Leader>tt",
        function()
          require("trouble").toggle("diagnostics")
        end,
        desc = "Toggle diagnostics panel (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix item",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous TODO comment",
      },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      {
        "<Leader>th",
        "<Cmd>ToggleTerm direction=horizontal<CR>",
        desc = "Toggle terminal in horizontal split (ToggleTerm)",
      },
      {
        "<Leader>tv",
        "<Cmd>ToggleTerm size=80 direction=vertical<CR>",
        desc = "Toggle terminal in vertical split (ToggleTerm)",
      },
      {
        "<Leader>tf",
        "<Cmd>ToggleTerm direction=float<CR>",
        desc = "Toggle floating terminal (ToggleTerm)",
      },
      {
        "<F7>",
        "<Cmd>ToggleTerm<CR>",
        desc = "Toggle terminal (ToggleTerm)",
      },
    },
    opts = {
      highlights = {
        Normal = { link = "Normal" },
        NormalNC = { link = "NormalNC" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
        StatusLine = { link = "StatusLine" },
        StatusLineNC = { link = "StatusLineNC" },
        WinBar = { link = "WinBar" },
        WinBarNC = { link = "WinBarNC" },
      },
      --@param term Terminal
      on_create = function()
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.signcolumn = "no"
      end,
      shading_factor = 2,
      float_opts = {
        border = "rounded",
      },
    },
  },
}

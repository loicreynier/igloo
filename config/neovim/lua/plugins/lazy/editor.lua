local utils = require("utils")

---@type LazySpec
return {
  -- Smart comment insertion
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true, opts = { enable_autocmd = false } },
    },
    keys = {
      { "gc", mode = "v" },
      { "gb", mode = "v" },
      { "gcc" },
      { "gbc" },
      { "gco" },
      { "gcO" },
      { "gcA" },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- Smart indents
  {
    "NMAC427/guess-indent.nvim",
    lazy = false,
    cmd = "GuessIndent",
    opts = {
      auto_cmd = true,
      buftype_exclude = utils.disabled_buftypes,
      filetype_exclude = utils.disabled_filetypes,
    },
    config = function(_, opts) require("guess-indent").setup(opts) end,
  },

  -- Smart visual whitespace
  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "ModeChanged *:[vV\22]", -- Lazy load when entering visual mode
    opts = {
      ignore = {
        filetypes = utils.disabled_filetypes,
        buftypes = utils.disabled_buftypes,
      },
    },
    config = function() require("visual-whitespace").setup({}) end,
  },

  -- Smart column
  {
    "m4xshen/smartcolumn.nvim",
    enabled = not require("system").is_slow,
    event = "VeryLazy",
    opts = {
      disabled_filetypes = require("utils").disabled_filetypes,
      custom_colorcolumn = function()
        return vim.b[0].editorconfig
            and vim.b[0].editorconfig.max_line_length ~= "off"
            and vim.b[0].editorconfig.max_line_length
          or "80"
      end,
    },
  },

  -- Keymaps help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
    },
    keys = {
      {
        "<Leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Show Buffer Local Keymaps (WhichKey)",
      },
    },
  },

  -- File explorer
  {
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
  },

  -- Better diagnostic list and tools
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
    keys = {
      {
        "<Leader>xx",
        "<Cmd>Trouble diagnostics toggle<CR>",
        desc = "Toggle diagnostics panel (Trouble)",
      },
      {
        "<Leader>xX",
        "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Toggle buffer diagnostics panel (Trouble)",
      },
      {
        "<Leader>xq",
        "<Cmd>Trouble qflist toggle<CR>",
        desc = "Toggle quickfix panel (Trouble)",
      },
      {
        "<Leader>xl",
        "<Cmd>Trouble loclist toggle<CR>",
        desc = "Toggle location list panel (Trouble)",
      },
      {
        "<Leader>cs",
        "<Cmd>Trouble symbols toggle<CR>",
        desc = "Toggle document symbols panel (Trouble)",
      },
      {
        "<Leader>cS",
        "<Cmd>Trouble lsp toggle<CR>",
        desc = "Toggle LSP references/definitions/... panel (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            ---@diagnostic disable-next-line: missing-parameter, missing-fields
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Previous Trouble/Quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            ---@diagnostic disable-next-line: missing-parameter, missing-fields
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Next Trouble/Quickfix item",
      },
    },
  },

  -- Smart TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {},
    keys = {
      {
        "]t",
        function() require("todo-comments").jump_next() end,
        desc = "Next TODO comment",
      },
      {
        "[t",
        function() require("todo-comments").jump_prev() end,
        desc = "Previous TODO comment",
      },
      {
        "<Leader>st",
        "<Cmd>TodoTelescope<CR>",
        desc = "Find todo comments (Telescope)",
      },
      {
        "<Leader>xt",
        "<Cmd>TodoTrouble toggle<CR>",
        desc = "Toggle TODO comments panel (Trouble)",
      },
    },
  },
}

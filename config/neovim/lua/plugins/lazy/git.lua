---@type LazySpec
return {
  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    events = { "BufWinEnter", "BufNewFile" },
    init = function()
      require("which-key").add({
        "<Leader>g",
        mode = { "n", "v" },
        group = "Git",
        icon = require("rice").icons.git.logo,
      })
    end,
    ---@module "gitsigns.config"
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Git hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Git hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Git hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Git hunk")

        -- Staging
        map({ "n", "v" }, "<leader>ghs", "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk")
        map({ "n", "v" }, "<leader>ghr", "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Git stage buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Git reset buffer")

        -- Preview/Diff/Blame
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Git hunk (inline)")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Git blame line")
        map("n", "<leader>ghB", function() gs.blame() end, "Git blame buffer")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Git hunk (Gitsigns)")

        -- Load `git-conhflict` (lazy-loaded on `GitConflictRefresh` trigger)
        vim.cmd("GitConflictRefresh")
      end,
    },
  },
  {
    "gitsigns.nvim",
    opts = function()
      Snacks.toggle({
        name = "Git Signs",
        get = function() return require("gitsigns.config").config.signcolumn end,
        set = function(state) require("gitsigns").toggle_signs(state) end,
      }):map("<leader>uG")
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    cmd = "GitConflictRefresh",
    init = function() require("which-key").add({ { "<Leader>gx", group = "Conflict" } }) end,
    keys = {
      {
        "<Leader>gxo",
        "<Plug>(git-conflict-ours)",
        desc = "Pick ours branch (GitConflict)",
      },
      {
        "<Leader>gxt",
        "<Plug>(git-conflict-theirs)",
        desc = "Pick theirs branch (GitConflict)",
      },
      {
        "<Leader>gxa",
        "<Plug>(git-conflict-both)",
        desc = "Pick both branch (GitConflict)",
      },
      {
        "<Leader>gx0",
        "<Plug>(git-conflict-none)",
        desc = "Pick none (GitConflict)",
      },
      {
        "[x",
        "<Plug>(git-conflict-prev-conflict)",
        desc = "Previous Git conflict",
      },
      {
        "]x",
        "<Plug>(git-conflict-next-conflict)",
        desc = "Next Git conflict",
      },
    },
    ---@module "git-conflict"
    ---@type GitConflictUserConfig
    opts = {
      disable_diagnostics = false,
      default_commands = true, -- Required for `GitConflictRefresh`
      default_mappings = true,
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },

  {
    "yutkat/git-rebase-auto-diff.nvim",
    ft = { "gitrebase" },
    opts = {
      size = vim.fn.float2nr(vim.o.lines * 0.33),
      run_show = true,
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    event = "BufReadPost",
    init = function()
      vim.keymap.set("n", "<Leader>gd", function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd("DiffviewOpen")
        else
          vim.cmd("DiffviewClose")
        end
      end, { desc = "Toggle Diffview", silent = true })
    end,
    opts = {
      use_icons = true,
      show_help_hints = false,
      diff_binaries = false,
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
      },
    },
  },

  -- GitHub actions tree-sitter highlighting
  {
    "Hdoc1509/gh-actions.nvim",
    dev = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function() require("gh-actions.tree-sitter").setup({ fromGrammar = true }) end,
  },
}

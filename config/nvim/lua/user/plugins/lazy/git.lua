local icons = require("user.rice").icons.git

---@module "lazy.types"
---@type LazySpec[]
return {
  --- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufWinEnter", "BufNewFile" },
    ---@module "gitsigns.config"
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      signs = {
        delete = {
          text = "_", -- Default
          show_count = true,
        },
      },
      count_chars = {
        [1] = "",
        [2] = "₂",
        [3] = "₃",
        [4] = "₄",
        [5] = "₅",
        [6] = "₆",
        [7] = "₇",
        [8] = "₈",
        [9] = "₉",
        ["+"] = "₊",
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

        -- Navigation mappings
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Git hunk")
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Previous Git hunk")
        map("n", "]C", function() gs.nav_hunk("last") end, "Last Git hunk")
        map("n", "[C", function() gs.nav_hunk("first") end, "First Git hunk")

        -- Staging mappings
        map({ "n", "v" }, "<Leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", "Git stage hunk")
        map({ "n", "v" }, "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", "Git reset hunk")
        map("n", "<Leader>gS", gs.stage_buffer, "Git stage buffer")
        map("n", "<Leader>gR", gs.reset_buffer, "Git reset buffer")

        -- Preview/Blame mappings
        map("n", "<Leader>gp", gs.preview_hunk_inline, "Preview Git hunk (inline)")
        map("n", "<Leader>gb", gs.toggle_current_line_blame, "Toggle current line Git Blame")

        -- Text object mappings
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "inner Git Hunk (Gitsigns)")
      end,
    },
  },
  {
    "gitsigns.nvim",
    opts = function()
      if Snacks then
        Snacks.toggle({
          name = "Git signs",
          get = function() return require("gitsigns.config").config.signcolumn end,
          set = function(state) require("gitsigns").toggle_signs(state) end,
        }):map("<Leader>uG")
      end
    end,
  },

  -- Diff viewer
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    init = function() require("which-key").add({ { "<Leader>gd", group = "Diff", icon = icons.diff } }) end,
    keys = {
      {
        "<Leader>gdr",
        function()
          vim.ui.input({ prompt = "Codediff Revision (empty for Git status)" }, function(revision)
            if revision and revision ~= "" then
              vim.cmd("CodeDiff " .. revision)
            else
              vim.cmd("CodeDiff")
            end
          end)
        end,
        desc = "Git Revision (CodeDiff)",
      },
      {
        "<Leader>gdf",
        "<Cmd>CodeDiff history %<CR>",
        desc = "Git file history (CodeDiff)",
      },
    },
    opts = {
      keymaps = {
        view = {
          toggle_stage = "s",
        },
        conflict = {
          accept_incoming = "<Leader>xt",
          accept_current = "<Leader>xo",
          accept_both = "<Leader>xb",
          discard = "<Leader>xx",
          next_conflict = "]x",
          prev_conflict = "[x",
        },
      },
      highlights = {
        char_brightness = 1,
      },
    },
  },

  -- Diff in interactive rebase edit
  {
    -- "yutkat/git-rebase-auto-diff.nvim",
    "loicreynier/git-rebase-auto-diff.nvim",
    branch = "fix/worktrees",
    ft = { "gitrebase" },
    opts = {
      size = vim.fn.float2nr(vim.o.lines * 0.33),
      run_show = true,
    },
  },
}

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

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
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Git stage hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Git stage buffer")
      map("n", "<leader>ghR", gs.reset_buffer, "Git reset buffer")

      -- Preview/Diff/Blame
      map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Git hunk (inline)")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Git blame line")
      map("n", "<leader>ghB", function() gs.blame() end, "Git blame buffer")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Git hunk (Gitsigns)")
    end,
  },
}

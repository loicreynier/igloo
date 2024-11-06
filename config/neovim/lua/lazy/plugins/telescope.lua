--[[-- Telescope

  "Gaze deeply into unknown regions using the power of the moon"

  Telescope's LSP related action keymaps are defined in `lsp.lua`

--]]

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  specs = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  Cmd = "Telescope",
  keys = {
    -- "Main" actions
    {
      "<C-p>",
      "<Cmd>Telescope find_files<CR>",
      desc = "Find files (Telescope)",
    },
    {
      "<C-M-p>",
      "<Cmd>Telescope<CR>",
      desc = "Telescope prompt",
    },
    {
      "<Leader><Leader>",
      "<Cmd>Telescope buffers<CR>",
      desc = "Switch buffer (Telescope)",
    },
    {
      "<Leader>:",
      "<Cmd>Telescope command_history<CR>",
      desc = "Command History (Telescope)",
    },
    {
      "<Leader>/",
      "<Cmd>Telescope live_grep<CR>",
      desc = "Live grep (Telescope)",
    },
    -- "Find" actions
    {
      "<Leader>fb",
      "<Cmd>Telescope buffers<CR>",
      desc = "Switch buffer (Telescope)",
    },
    {
      "<Leader>ff",
      "<Cmd>Telescope find_files<CR>",
      desc = "Find files (Telescope)",
    },
    {
      "<Leader>fr",
      "<Cmd>Telescope oldfiles<CR>",
      desc = "Find recent files (Telescope)",
    },
    {
      "<Leader>fg",
      "<Cmd>Telescope git_files<CR>",
      desc = "Find Git files (Telescope)",
    },
    {
      "<Leader>fk",
      "<Cmd>Telescope keymaps<CR>",
      desc = "Find keymaps (Telescope)",
    },
    -- "Search" actions
    {
      "<Leader>sk",
      "<Cmd>Telescope keymaps<CR>",
      desc = "Search keymaps (Telescope)",
    },
    {
      "<Leader>sm",
      "<Cmd>Telescope man_pages<CR>",
      desc = "Search man pages (Telescope)",
    },
    {
      "<Leader>so",
      "<Cmd>Telescope vim_options<CR>",
      desc = "Search Vim options (Telescope)",
    },
    {
      "<Leader>sh",
      "<Cmd>Telescope help_tags<CR>",
      desc = "Search help tags (Telescope)",
    },
    {
      "<Leader>sH",
      "<Cmd>Telescope highlights<CR>",
      desc = "Search highlights groups (Telescope)",
    },
    {
      "<Leader>sd",
      "<Cmd>Telescope diagnostics<CR>",
      desc = "Search workspace diagnostics (Telescope)",
    },
    {
      "<Leader>sD",
      "<Cmd>Telescope diagnostics bufnr=0<CR>",
      desc = "Search buffer diagnostics (Telescope)",
    },
    {
      "<Leader>sq",
      "<Cmd>Telescope quickfix<CR>",
      desc = "Search quickfix items (Telescope)",
    },
    {
      "<Leader>sl",
      "<Cmd>Telescope loclist<CR>",
      desc = "Search location list (Telescope)",
    },
  },
  opts = function()
    local actions = require("telescope.actions")
    local os_sep = require("plenary.path").path.sep

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["jj"] = { "<Esc>", type = "command" },
            ["jk"] = { "<Esc>", type = "coprevmmand" },
            ["<C-y>"] = actions.select_default,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-u>"] = false, -- Clear prompt instead of scroll the preview
            ["<M-u>"] = actions.preview_scrolling_up,
            ["<M-d>"] = actions.preview_scrolling_down,
          },
        },
        history = {
          path = vim.fn.stdpath("state") .. os_sep .. "telescope_history",
        },
      },
      pickers = {
        buffers = {
          sort_mru = true,
          sort_lastused = true,
        },
      },
    }
  end,
}

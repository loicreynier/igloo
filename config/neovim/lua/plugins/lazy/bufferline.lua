return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Switch to previous buffer (BufferLine)" },
    { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Switch to next buffer (BufferLine)" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer previous (BufferLine)" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next (BufferLine)" },
    { "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle buffer pin (BufferLine)" },
    { "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers (BufferLine)" },
    { "<Leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers (BufferLine)" },
    { "<Leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right (BufferLine)" },
    { "<Leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left (BufferLine)" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      -- Don't get too fancy as this function will be executed a lot
      diagnostics_indicator = function(_, _, diag)
        local icons = require("rice").icons.diagnostics
        local code = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(code)
      end,
      always_show_bufferline = true,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "center",
        },
        {
          filetype = "DiffviewFiles",
          text = "Source Control",
          highlight = "Directory",
          text_align = "center",
        },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          ---@diagnostic disable-next-line: undefined-global
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}

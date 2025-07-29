--[[-- Noice

  Cool looking UI :sunglasses:

--]]

---@type LazySpec
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  keys = {
    { "<Leader>sn", "<Cmd>Noice telescope<CR>", desc = "Search Noice notifications (Telescope)" },
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    ---@type NoicePresets
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    require("noice").setup(opts)
    telescope.load_extension("noice")
  end,
}

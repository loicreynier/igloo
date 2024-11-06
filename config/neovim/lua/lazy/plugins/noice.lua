--[[-- Noice

  Cool looking UI :sunglasses:

--]]

return {
  "folke/noice.nvim",
  version = "<=4.4.7", -- FIX: https://github.com/folke/noice.nvim/issues/938
  event = "VeryLazy",
  override = {
    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    ["vim.lsp.util.stylize_markdown"] = true,
    ["cmp.entry.get_documentation"] = true,
  },
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}

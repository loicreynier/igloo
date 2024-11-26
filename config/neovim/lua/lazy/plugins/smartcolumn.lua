return {
  "m4xshen/smartcolumn.nvim",
  event = "VeryLazy",
  opts = {
    disabled_filetypes = {
      "help",
      "checkhealth",
      "lspinfo",
      "lazy",
      "alpha",
      "noice",
      "Trouble",
      "neo-tree",
      "NvimTree",
    },
    custom_colorcolumn = function()
      local column = 81
      if vim.b[0].editorconfig and vim.b[0].editorconfig.max_line_length then
        column = vim.b[0].editorconfig.max_line_length
      end

      return column
    end,
  },
}

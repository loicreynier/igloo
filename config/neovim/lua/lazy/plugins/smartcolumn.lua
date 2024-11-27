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
      return vim.b[0].editorconfig
          and vim.b[0].editorconfig.max_line_length ~= "off"
          and vim.b[0].editorconfig.max_line_length
        or "80"
    end,
  },
}

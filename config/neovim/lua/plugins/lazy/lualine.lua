return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- Set an empty statusline till it loads
      vim.o.statusline = " "
    else
      -- Hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: "we don't need this `lualine` require madness" - LazyVim
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local opts = {
      options = {
        theme = "auto",
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "ministarter " },
        },
      },
      sections = {
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          -- Word count for text, Markdown and TeX
          {
            function()
              if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
                return vim.fn.wordcount().visual_words .. " words"
              else
                return vim.fn.wordcount().words .. " words"
              end
            end,
            cond = function() return vim.tbl_contains({ "text", "markdown", "tex" }, vim.bo.filetype) end,
          },
        },
      },
      extensions = { "neo-tree", "lazy" },
    }

    return opts
  end,
}

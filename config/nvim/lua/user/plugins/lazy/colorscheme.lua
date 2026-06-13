local priority = 1000

---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = priority,
    opts = function()
      local colors = require("vscode.colors").get_colors()
      return {
        terminal_colors = true,
        transparent = true,
        italic_inlayhints = true,
        group_overrides = {
          -- Telescope and pickers
          FloatBorder = { fg = colors.vscLineNumber, bg = "None" },
          TelescopePromptBorder = { link = "FloatBorder" },
          TelescopeResultBorder = { link = "FloatBorder" },
          TelescopePreviewBorder = { link = "FloatBorder" },

          -- Snacks dashboard
          SnacksDashboardHeader = { fg = colors.vscBlue, bg = "None" },
          SnacksDashboardDesc = { fg = colors.vscYellow, bg = "None" },
          SnacksDashboardIcon = { fg = colors.vscOrange, bg = "None" },
          SnacksDashboardKey = { fg = colors.vscPink, bg = "None" },
          SnacksDashboardFooter = { fg = colors.vscBlue, bg = "None" },
          SnacksDashboardSpecial = { fg = colors.vscOrange, bg = "None" },

          -- Mini snippets
          MiniSnippetsCurrent = { link = "SnippetTabStop" },
          MiniSnippetsCurrentReplace = { link = "MiniSnippetsCurrent" },
          MiniSnippetsCurrentFinal = { link = "MiniSnippetsCurrent" },
          MiniSnippetsCurrentUnvisited = { link = "MiniSnippetsCurrent" },
          MiniSnippetsCurrentVisited = { link = "MiniSnippetsCurrent" },
        },
      }
    end,
    config = function(_, opts)
      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
    cond = function() return vim.env.SYSTEM_THEME == nil or vim.env.SYSTEM_THEME == "base16" end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = priority,
    opts = {},
    config = function() vim.cmd.colorscheme("tokyonight-storm") end,
    cond = function() return vim.env.SYSTEM_THEME == "tokyonight" end,
  },
}

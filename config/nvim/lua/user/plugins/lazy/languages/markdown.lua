local sinfo = vim.g.sinfo

---@type LazySpec[]
return {
  -- Improve rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = "markdown",
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      heading = {
        sign = true,
        icons = {}, -- Keep "#+" headings
      },
      completions = {
        blink = { enabled = vim.g.cmp_engine == "blink" },
        lsp = { enabled = vim.g.cmp_engine == "nvim" },
      },
    },
  },

  -- Preview in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
    enabled = not sinfo.is_ssh,
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
    end,
  },

  -- Navigation and utils
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {
      modules = {
        bib = false,
        buffers = false,
        conceal = false,
        cursor = false,
        foldtext = false,
        links = false,
        lists = false,
        maps = true,
        paths = false,
        tables = true,
        to_do = false,
        yaml = false,
        completion = false,
        notebook = false,
      },
    },
  },
}

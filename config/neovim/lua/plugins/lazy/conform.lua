--[[-- conform.nvim

  Lightweight formatter with LSP integration and support for injected languages/code blocks.

--]]

local use_mason = require("system").use_mason == true

---@type  LazySpec
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  dependencies = { "LittleEndianRoot/mason-conform", enabled = use_mason, dependencies = { "mason-org/mason.nvim" } },
  cmd = "ConformInfo",
  keys = {
    {
      "<Leader>cf",
      function() require("conform").format({ async = true, lsp_fallback = "true" }) end,
      mode = { "n", "v" },
      desc = "Format buffer or selection (Conform)",
    },
    {
      "<Leader>cF",
      function() require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 }) end,
      mode = { "n", "v" },
      desc = "Format injected languages/code blocks (Conform)",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if not require("utils.format").enabled(bufnr) then return end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      c = { "clang_format" },
      cpp = { "clang_format" },
      cuda = { "clang_format" },
      fortran = { "fprettify" },
      just = { "just" },
      lua = { "stylua" },
      python = { "ruff_format" }, -- Ruff subcommand
      sh = { "shfmt" },
    },
    formatters = {
      clang_format = { args = { "--style=file", "--fallback-style=LLVM" } },
      fprettify = { args = { "--indent=4", "--line-length=100" } },
      stylua = {
        condition = function(ctx)
          return vim.fs.find({ "stylua.toml", ".stylua.toml" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  config = function(_, opts)
    require("conform").setup(opts)
    require("mason-conform").setup({})
  end,
}

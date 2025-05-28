--[[-- conform.nvim

  Lightweight formatter with LSP integration

--]]

return {
  "stevearc/conform.nvim",
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
}

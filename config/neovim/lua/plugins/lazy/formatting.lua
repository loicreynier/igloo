local use_mason = require("system").use_mason == true

---@type LazySpec
return {
  -- conform.nvim
  -- Lightweight formatter with LSP integration and support for injected languages/code blocks.
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
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
        tex = { "tex-fmt" },
      },
      formatters = {
        clang_format = { args = { "--style=file", "--fallback-style=LLVM" } },
        fprettify = { args = { "--indent=4", "--line-length=100" } },
        latexindent = {
          condition = function(ctx)
            return vim.fs.find({ ".latexindent.yaml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        stylua = {
          condition = function(ctx)
            return vim.fs.find({ "stylua.toml", ".stylua.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },

  -- Only format modified code with `FormatModified` from LSP capabilities
  {
    "joechrisellis/lsp-format-modifications.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.api.nvim_create_user_command("FormatModified", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({
          bufnr = bufnr,
          method = "textDocument/rangeFormatting",
        })

        if #clients == 0 then
          Snacks.notify.error(
            "Format request failed, no matching language servers",
            { title = "LSP format modified only" }
          )
        end

        for _, client in pairs(clients) do
          require("lsp-format-modifications").format_modifications(client, bufnr)
        end
      end, {})
    end,
  },
}

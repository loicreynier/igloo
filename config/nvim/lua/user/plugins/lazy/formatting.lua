---@module "lazy.types"
---@type LazySpec[]
return {
  -- Conform
  -- Lightweight formatter with LSP integration and support for injected languages/code blocks
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        if not require("user.utils.format").enabled(bufnr) then return end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {},
    },
    init = function() vim.o.formatexpr = "v:lua.require('conform').formatexpr()" end,
  },

  -- Only format Git modified code with `LspFormatModified` from LSP capabilities
  {
    "joechrisellis/lsp-format-modifications.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.api.nvim_create_user_command("LspFormatModified", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({
          bufnr = bufnr,
          method = "textDocument/rangeFormatting",
        })

        if #clients == 0 then
          Snacks.notify.error(
            "Format request failed, no matching language servers",
            { title = "LSP: format modified only" }
          )
        end

        for _, client in pairs(clients) do
          require("lsp-format-modifications").format_modifications(client, bufnr)
        end
      end, {})
    end,
  },
}

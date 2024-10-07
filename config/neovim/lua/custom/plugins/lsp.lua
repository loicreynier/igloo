return {
  {
    "neovim/nvim-lspconfig",

    config = function()
      local lspconfig = require("lspconfig")
      local conform = require("conform")

      local servers = {
        ruff = {},
      }

      for name, config in pairs(servers) do
        lspconfig[name].setup(config)
      end
    end,
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",

    config = function()
      local lsp_lines = require("lsp_lines")

      -- Disable virtual_text since it's redundant
      -- vim.diagnostic.config({ virtual_text = false })

      -- Doesn't work if not called here while using `config`
      lsp_lines.setup()

      -- Disable by default...
      vim.diagnostic.config {
        virtual_text = true,
        virtual_lines = false,
      }

      -- ... then use keymap to toggle
      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Change diagnostic style (virtual text / `lsp_lines`)" })
    end,
  },
}

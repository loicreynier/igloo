-- LSP plugins
return {
  {
    "neovim/nvim-lspconfig",
    -- dependencies = {
    --   {
    --     "folke/neoconf.nvim",
    --     cmd = "Neoconf",
    --     opts = {},
    --   }
    -- },
    config = function()
      local lspconfig = require("lspconfig")

      ---@diagnostic disable-next-line: undefined-field
      local fs_stat = (vim.loop or vim.uv).fs_stat

      local has_self_install = not (
        vim.tbl_contains(vim.g.system_options, "nix") or
        vim.tbl_contains(vim.g.system_options, "offline")
      )

      local servers = {
        lua_ls = {
          -- Recommended configuration for Neovim code linting:
          -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if fs_stat(path .. '/.luarc.json') or fs_stat(path .. '/.luarc.jsonc') then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT'
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                }
              }
            })
          end,
          settings = {
            Lua = {},
          },
        },
        fortls = {
          cmd = {
            "fortls",
            "--notify_init",
            not has_self_install and "--disable_autoupdate" or nil,
            "--hover_signature",
            "--hover_language=fortran",
            "--use_signature_help",
            "--lowercase_intrinsics",
          },
        },
        ruff = {},
      }

      for name, config in pairs(servers) do
        lspconfig[name].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = 0 }
          local set = vim.keymap.set

          -- TODO: add descriptions
          set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
          set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
          set("n", "K", function() vim.lsp.buf.hover() end, opts)
          set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
          set("n", "gr", function() vim.lsp.buf.references() end, opts)
          set("n", "gr", function() vim.lsp.buf.type_definition() end, opts)
          set("n", "<Leader>ca", function() vim.lsp.buf.code_action() end, opts)
          set("n", "<Leader>cr", function() vim.lsp.buf.rename() end, opts)
        end
      })
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
      vim.keymap.set("", "<Leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Change diagnostic style (virtual text / `lsp_lines`)" })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        sh = { "shfmt" },
      },
    },
  },
}

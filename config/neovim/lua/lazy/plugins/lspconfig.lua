local has_self_install = require("system").has_self_install

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/neoconf.nvim",
      cmd = "Neoconf",
      opts = {},
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    ---@diagnostic disable-next-line: undefined-field
    local fs_stat = (vim.loop or vim.uv).fs_stat

    local ltex_path = function()
      local path
      ---@diagnostic disable-next-line: undefined-field
      local git_root = util.find_git_ancestor(vim.loop.cwd())

      if git_root then
        if #vim.fn.glob(git_root .. "/.vscode" .. "/ltex.*", true, true) == 0 then
          path = git_root .. "/.ltex"
        else
          path = git_root .. "/.vscode"
        end
      else
        path = vim.fn.stdpath("data") .. "/ltex"
      end

      return path
    end

    local servers = {
      clangd = {},
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
      ltex = { -- FIXME: dictionaries don't load on startup
        on_attach = function(_, _)
          require("ltex_extra").setup({
            init_check = true,
            path = ltex_path(),
          })
        end,
        settings = {
          ltex = {
            checkFrequency = "save",
          },
        },
      },
      lua_ls = {
        -- Recommended configuration for Neovim code linting:
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if fs_stat(path .. "/.luarc.json") or fs_stat(path .. "/.luarc.jsonc") then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      },
      nil_ls = {
        formatting = { command = { "alejandra", "--quiet", "--" } },
      },
      pylsp = {
        plugins = {
          ruff = {
            enabled = true,
            format = true,
          },
        },
      },
      -- ruff = {}, -- Use `pylsp` plugin instead for renaming
      taplo = {},
      -- tinymist = {
      --   formatterMode = "typstyle",
      --   exportPdf  = "onSave",
      -- },
      texlab = {
        latexFormatter = "texlab", -- Not implemented yet
      },
      typos_lsp = {
        init_options = {
          diagnosticSeverity = "Warning",
        },
      },
    }

    for name, config in pairs(servers) do
      lspconfig[name].setup(config)
    end

    -- Cannot be parsed by previous loop: "Cannot serialize function"
    lspconfig["typos_lsp"].setup({
      on_attach = function(client, _) -- , bufnr)
        -- We could also check if LTeX is loaded with something like
        --
        -- for _, lsp in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        --   if lsp.name == "ltex" then
        --     vim.lsp.stop_client(client.id, true)
        --   end
        -- end
        --
        -- but Typos LSP loads way faster than LTeX so it doesn't seems to work.

        local disabled_filetypes = vim.iter({ "markdown", "tex", "plaintex", "help" })
        if disabled_filetypes:find(vim.bo.filetype) ~= nil then
          vim.lsp.stop_client(client.id, true)
        end
      end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = 0 }
        local telescope = require("telescope.builtin")
        local set = vim.keymap.set

        -- TODO: add descriptions
        set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        set("n", "K", function() vim.lsp.buf.hover() end, opts)
        -- set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        set("n", "gd", function() telescope.lsp_definitions({ reuse_win = true }) end, opts)
        set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        -- set("n", "gr", function() vim.lsp.buf.references() end, opts)
        set("n", "gr", function() telescope.lsp_references() end, opts)
        -- set("n", "gT", function() vim.lsp.buf.type_definition() end, opts)
        set("n", "gT", function() telescope.lsp_type_definition() end, opts)
        -- set("n", "gI", function() vim.buf.implementations() end, opts)
        set("n", "gI", function() telescope.lsp_implementations() end, opts)
        set("n", "<Leader>ca", function() vim.lsp.buf.code_action() end, opts)
        set("n", "<Leader>cr", function() vim.lsp.buf.rename() end, opts)
      end,
    })
  end,
}

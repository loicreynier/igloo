local system = require("system")
local use_mason = system.has_self_install and not system.is_nix

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason-lspconfig.nvim",
      enabled = use_mason,
      config = function() end,
      dependencies = { "mason-org/mason.nvim" },
    },
    { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
  },
  config = function()
    ---@diagnostic disable-next-line: undefined-field
    local fs_stat = (vim.loop or vim.uv).fs_stat
    local lspconfig = require("lspconfig")
    local map_lsp_keybinds = require("config.keymaps").map_lsp_keybinds
    local on_attach = function(_, bufnr) map_lsp_keybinds(bufnr) end

    local servers = {
      clangd = {
        mason = system.arch ~= "aarch64",
      },
      fortls = {
        mason = system.name ~= "HPCC_Olympe",
        cmd = {
          "fortls",
          "--notify_init",
          not (system.has_self_install or system.is_nix) and "--disable_autoupdate" or nil,
          "--hover_signature",
          "--hover_language=fortran",
          "--use_signature_help",
          "--lowercase_intrinsics",
        },
      },
      jsonls = {
        mason = use_mason and vim.fn.executable("npm"),
      },
      ltex = {
        mason = false,
        settings = {
          ltex = {
            checkFrequency = "save",
          },
        },
      },
      lua_ls = {
        mason = system.name ~= "HPCC_Turpan" and system.name ~= "HPCC_Olympe", -- GLIBC issue
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
      neocmake = {
        mason = false,
      },
      nil_ls = system.set_if_nix({
        mason = false,
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt", "--quiet" },
            },
          },
        },
      }, nil),
      pylsp = {
        mason = system ~= "HPCC_Olympe",
        settings = {
          plugins = {
            ruff = {
              enabled = true,
              format = true,
            },
          },
        },
      },
      taplo = {
        mason = system ~= "HPCC_Olympe",
      },
      -- tinymist = {
      --   settings = {
      --     formatterMode = "typstyle",
      --     exportPdf = "onSave",
      --   },
      -- },
      texlab = {
        mason = system.name ~= "HPCC_Turpan",
        settings = {
          latexFormatter = "texlab", -- Not implemented yet
        },
      },
      typos_lsp = {
        mason = system.name ~= "HPCC_Olympe" and system.name ~= "HPCC_Turpan", -- GLIBC issue
        init_options = {
          diagnosticSeverity = "Hint",
        },
        on_attach = function(client, bufnr)
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
          if disabled_filetypes:find(vim.bo.filetype) ~= nil then vim.lsp.stop_client(client.id, true) end
          return on_attach(client, bufnr)
        end,
      },
    }

    local ensure_installed = {}
    for name, config in pairs(servers) do
      lspconfig[name].setup({
        on_attach = config.on_attach or on_attach,
        on_init = config.on_init,
        init_options = config.init_options,
        settings = config.settings,
      })
      if config.mason ~= false then ensure_installed[#ensure_installed + 1] = name end
    end

    if use_mason then
      require("mason-lspconfig").setup({
        automatic_enable = {},
        ensure_installed = ensure_installed,
      })
    end
  end,
}

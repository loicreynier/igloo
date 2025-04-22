local system = require("system")
local has_self_install = system.has_self_install

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", enabled = system.has_self_install },
    { "williamboman/mason-lspconfig.nvim", enabled = system.has_self_install, config = function() end },
    { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    ---@diagnostic disable-next-line: undefined-field
    local fs_stat = (vim.loop or vim.uv).fs_stat

    local servers = {
      clangd = {
        mason = system.arch ~= "aarch64",
      },
      fortls = {
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
        mason = system.has_self_install and vim.fn.executable("npm"),
      },
      ltex = {
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
      neocmake = {},
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
    }

    local ensure_installed = {}
    for name, config in pairs(servers) do
      lspconfig[name].setup(config)
      if config.mason ~= false then ensure_installed[#ensure_installed + 1] = name end
    end

    -- Cannot be parsed by previous loop: "Cannot serialize function"
    lspconfig["typos_lsp"].setup({
      init_options = {
        diagnosticSeverity = "Hint",
      },
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
        if disabled_filetypes:find(vim.bo.filetype) ~= nil then vim.lsp.stop_client(client.id, true) end
      end,
    })
    if system.name ~= "HPCC_Olympe" and system.arch ~= "aarch64" then
      ensure_installed[#ensure_installed + 1] = "typos_lsp"
    end

    -- Overrides for Olympe which has GLIBC problems
    if system.name == "HPCC_Olympe" then
      ensure_installed = {
        "fortls",
        "lua_ls",
        "pylsp",
        "taplo",
      }
    end

    if system.has_self_install then
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_installation = false,
      })
    end

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

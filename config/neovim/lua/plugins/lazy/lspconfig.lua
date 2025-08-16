--[[-- LSP configuration

  Following Neovim 0.11+, LSP servers can be configured and enabled directly using the Neovim API
  (see `vim.lsp.config` and `vim.lsp.enable`). `nvim-lspconfig` is "data only" community-driven plugin that provides
  default LSP Neovim configurations.

  LSP keybindings are set *globally* through the "LspAttach" autocommand which is ran whenever *any* LSP client
  attaches to a buffer. They could also be set on a per-client basis through `Client:on_attach()`.
  On may note that "LspAttach" is run *after* `Client:on_attach`().
  Sources:
  - https://neovim.io/doc/user/lsp.html#LspAttach
  - https://neovim.io/doc/user/lsp.html#Client%3Aon_attach()

  When using Mason, LSP servers are installed if they are listed in `ensure_installed`.
  While `mason-lspconfig` can be used to enable Mason-installed servers, here, it is only used to bridge the gap
  between `nvim-lspconfig` names (e.g. "lua_ls") and Mason package names (e.g. "lua-language-server").

  TODO: use `mason-tool-installer` to configure auto-update of packages (and update start delay)?

  Neovim's API checks whether the configured LSP client binary is executable before attaching so there is no need
  to check if the binary is installed.

--]]

local system = require("system")
local use_mason = system.use_mason == true
local map_lsp_keybinds = require("config.keymaps").map_lsp_keybinds

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
  opts = function()
    ---@diagnostic disable-next-line: undefined-field
    local fs_stat = (vim.loop or vim.uv).fs_stat

    local opts = {
      servers = {
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
          mason = use_mason and system.has_node,
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
          mason = system.name ~= "HPCC_Turpan" and system.name ~= "HPCC_Olympe", -- GLIBC issue
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
          mason = system.is_hpcc == true,
          ettings = {
            latexFormatter = "texlab", -- NOTE: not implemented yet
          },
        },
        typos_lsp = {
          mason = system.name ~= "HPCC_Olympe" and system.name ~= "HPCC_Turpan", -- GLIBC issue
          init_options = {
            diagnosticSeverity = "Hint",
          },
          -- Disable for text files, LTeX already handles them
          on_attach = function(client, _)
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
        },
      },
    }
    return opts
  end,
  config = function(_, opts)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event) map_lsp_keybinds(event.buf) end,
    })

    local has_blink, blink = pcall(require, "blink.cmp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_blink and blink.get_lsp_capabilities() or {},
      opts.capabilities or {}
    )

    local servers = opts.servers
    local ensure_installed = {}
    for server, config in pairs(servers) do
      config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
      if config.mason ~= false then ensure_installed[#ensure_installed + 1] = server end
    end

    if use_mason then
      require("mason-lspconfig").setup({
        automatic_enable = false,
        ensure_installed = ensure_installed,
      })
    end
  end,
}

local system = require("system")

local function lspconfig()
  local on_attach_base = vim.lsp.config.texlab.on_attach
  ---@type vim.lsp.Config
  return {
    mason = system.is_hpcc ~= true,
    settings = {
      texlab = {
        latexFormatter = "tex-fmt",
        bibtexFormatter = "tex-fmt",
        build = {
          args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
          executable = "latexmk",
          forwardSearchAfter = false,
          onSave = false,
        },
      },
    },
    on_attach = function(client, bufnr)
      if not on_attach_base then return end
      on_attach_base(client, bufnr)

      local function toggle_buildOnSave(state)
        ---@diagnostic disable-next-line: undefined-field
        state = state or not client.config.settings.texlab.build.onSave
        vim.lsp.config("texlab", {
          settings = {
            texlab = {
              build = {
                onSave = state,
              },
            },
          },
        })
        vim.cmd("LspRestart texlab")
      end

      Snacks.toggle.new({
        id = "texlab_buildOnSave",
        name = "Toggle Texlab build on save",
        ---@diagnostic disable-next-line: undefined-field
        get = function() return client.config.settings.texlab.build.onSave end,
        set = function(state) return toggle_buildOnSave(state) end,
      })

      vim.api.nvim_create_user_command(
        "LspTexlabToggleBuildOnSave",
        function() Snacks.toggle.toggles.texlab_buildOnSave:toggle() end,
        {}
      )
    end,
  }
end

return lspconfig()

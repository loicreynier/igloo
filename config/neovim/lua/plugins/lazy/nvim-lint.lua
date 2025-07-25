--[[-- Non-LSP linters

  TODO: custom `lint` function from LazyVim
  TODO: check if linter is installed before `linters_by_ft`?

  Is `nvim-lint` better than `none-ls`?
  I'm not sure yet, LazyVim & NvChad use it while AstroNvim prefers `none-ls`.
  I've seen the argument that `nvim-lint` appears to be less likely to break
  with future Neovim updates.

--]]

local system = require("system")
local use_mason = system.has_self_install and not system.is_nix

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  dependencies = { "rshkarin/mason-nvim-lint", enabled = use_mason, dependencies = { "mason-org/mason.nvim" } },
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      bash = { "bash" },
      editorconfig = { "editorconfig-checker" }, -- TODO: run on all filetypes?
      gitcommit = { "gitlint" },
      dockerfile = { "hadolint" },
      make = { "checkmake" },
      markdwon = { "markdownlint" },
      nix = system.set_if_nix({ "nix", "deadnix", "statix" }, {}),
      sh = { "shellcheck" },
      yaml = { "yamllint" },
      ["yaml.ghactions"] = { "actionlint", "yamllint" },
      ["yaml.ansible"] = { "ansible-lint" },
    },
    linters = {
      -- Use `selene` only when a `selene.toml` file is present
      selene = {
        condition = function(ctx) return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1] end,
      },
    },
  },
  config = function(_, opts)
    local M = {}

    local lint = require("lint")

    -- Need to setup the linter "manually"
    -- Source: https://www.lazyvim.org/plugins/linting
    for name, linter in pairs(opts.linters) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        if type(linter.args) == "table" then
          lint.linters[name].args = lint.linters[name].args or {}
          vim.list_extend(lint.linters[name].args, linter.args)
        end
      else
        lint.linters[name] = linter
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    local linters_ignore_install = {
      "bash",
      "actionlint",
      "hadolint",
      "markdownlint",
    }
    if system.arch == "aarch64" then
      table.insert(linters_ignore_install, "clangd")
      table.insert(linters_ignore_install, "checkmake")
    end
    if not system.has_node then table.insert(linters_ignore_install, "markdownlint") end

    if use_mason then
      require("mason-nvim-lint").setup({
        quiet_mode = false,
        ensure_installed = {},
        automatic_installation = true,
        ignore_install = linters_ignore_install,
      })
    end

    -- Wrapper to unfreeze it linter is too slow
    -- Source: https://www.lazyvim.org/plugins/linting
    function M.debounce(ms, fn)
      ---@diagnostic disable-next-line: undefined-field
      local timer = vim.uv.new_timer()
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function() M.debounce(100, lint.try_lint()) end,
    })
  end,
}

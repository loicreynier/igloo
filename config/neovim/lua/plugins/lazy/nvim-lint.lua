--[[-- Non-LSP linters

  TODO: custom `lint` function from LazyVim

--]]

local system = require("system")
local use_mason = system.use_mason == true

---@type LazySpec
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
      selene = {
        -- Use `selene` only when a `selene.toml` file is present
        condition = function(ctx) return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1] end,
      },
    },
  },
  config = function(_, opts)
    local M = {}
    local lint = require("lint")

    -- Need to setup the linter "manually"
    -- Source: https://www.lazyvim.org/plugins/linting
    for linter, config in pairs(opts.linters) do
      if type(config) == "table" and type(lint.linters[linter]) == "table" then
        lint.linters[linter] = vim.tbl_deep_extend("force", lint.linters[linter], config)
        if type(config.args) == "table" then
          lint.linters[linter].args = lint.linters[linter].args or {}
          vim.list_extend(lint.linters[linter].args, config.args)
        end
      else
        lint.linters[linter] = config
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    local linters_ignore_install = {
      "bash",
    }
    if system.arch == "aarch64" then
      table.insert(linters_ignore_install, "clangd")
      table.insert(linters_ignore_install, "checkmake")
    end
    if system.is_hpcc then
      table.insert(linters_ignore_install, "actionlint")
      table.insert(linters_ignore_install, "ansible-lint")
      table.insert(linters_ignore_install, "hadolint")
      table.insert(linters_ignore_install, "markdownlint")
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

    -- Wrapper to unfreeze if linter is too slow
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

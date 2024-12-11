--[[-- Non-LSP linters

  TODO: custom `lint` function from LazyVim
  TODO: check if linter is installed before `linters_by_ft`?

  Is `nvim-lint` better than `none-ls`?
  I'm not sure yet, LazyVim & NvChad use it while AstroNvim prefers `none-ls`.
  I've seen the argument that `nvim-lint` appears to be less likely to break
  with future Neovim updates.

--]]

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      bash = { "bash" },
      editorconfig = { "editorconfig-checker" }, -- TODO: run on all filetypes?
      gitcommit = { "gitlint" },
      dockerfile = { "hadolint" },
      make = { "checkmake" },
      markdwon = { "markdownlint" },
      nix = require("system").set_if_nix({ "nix", "deadnix", "statix" }, {}),
      sh = { "shellcheck" },
      yaml = { "yamllint" },
      ["yaml.ghactions"] = { "actionlint", "yamllint" },
      ["yaml.ansible"] = { "ansiblelint" },
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

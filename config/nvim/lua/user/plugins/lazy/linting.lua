---@class Linter: lint.Linter
---@field name string

---@alias LinterSpec string|Linter

---@type { [string]: LinterSpec[] }
local linters_by_ft = {
  make = { "checkmake" },
  nix = { "nix", "deadnix", "statix" },
  sh = { "shellcheck" },
}

---@return LazySpec[]
return {
  {
    "mfussenegger/nvim-lint",
    ft = vim.tbl_keys(linters_by_ft),
    config = function()
      local lint = require("lint")
      local linters_by_ft_ = {}
      for ft, linters in pairs(linters_by_ft or {}) do
        for _, linter in ipairs(linters) do
          local linter_name = type(linter) == "string" and linter or linter.name
          local linter_plug = lint.linters[linter_name]
          if not linter_plug then
            vim.notify("Unknown linter: " .. linter_name, vim.log.levels.ERROR, { title = "Lint" })
          end
          ---@cast linter_plug lint.Linter
          -- Fusion with default config
          local linter_plug_extended =
            vim.tbl_deep_extend("force", vim.deepcopy(linter_plug), type(linter) == "table" and linter or {})
          linters_by_ft_[ft] = linters_by_ft_[ft] or {}
          table.insert(linters_by_ft_[ft], linter_name)
          lint.linters[linter_name] = linter_plug_extended
        end
      end
      lint.linters_by_ft = linters_by_ft_

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "TextChanged", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user.lint", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local ft = vim.bo[bufnr].filetype
          local linters = linters_by_ft_[ft]
          if not linters then return end

          -- If this is a `TextChanged` or `InsertLeave` event,
          -- only lint if there are linters that can accept standard input
          if event.event == "TextChanged" or event.event == "InsertLeave" then
            local any_stdin = vim.iter(linters):any(function(linter_name)
              local linter = lint.linters[linter_name]
              return linter.stdin
            end)
            if not any_stdin then return end
          end

          lint.try_lint()
        end,
      })
    end,
  },
}

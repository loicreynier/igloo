local system = require("system")

---@type LazySpec
return {
  -- Treesitter Neovim configuration
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = function()
      local ts = require("nvim-treesitter")
      if not ts.get_installed then
        vim.notify(
          "Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.",
          "error",
          { title = "Treesitter update" }
        )
        return
      end
    end,
    lazy = false,
    cmd = {
      "TSUpdate",
      "TSInstall",
      "TSLog",
      "TSUninstall",
    },
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      auto_install = system.has_self_install,
      ensure_installed = system.has_self_install and "all" or {},
      install_dir = vim.fs.joinpath(system.site_dir, "treesitter"),
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if vim.fn.executable("tree-sitter") == 0 then
        vim.notify(
          "`nvim-treesitter` requires the `tree-sitter` executable to be installed",
          "err",
          { title = "Treesitter setup" }
        )
        return
      end

      local ts = require("nvim-treesitter")
      if not ts.get_installed then
        vim.notify("Please update `nvim-treesitter`", "err", { title = "Treesitter update" })
      end
      ts.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.tbl_contains(ts.get_installed("parsers"), vim.bo[args.buf].filetype) then vim.treesitter.start() end
        end,
      })
    end,
  },

  -- Show Treesitter context
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = function()
      local tsc = require("treesitter-context")
      Snacks.toggle({
        name = "Treesitter context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map("<Leader>ut")
      return { mode = "cursor", max_lines = 3 }
    end,
  },

  -- Nix Home Manager queries
  { "calops/hmts.nvim" },
}

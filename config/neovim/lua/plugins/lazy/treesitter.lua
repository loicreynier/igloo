local system = require("system")

---@type LazySpec
return {
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
    lazy = vim.fn.argc(-1) == 0, -- Load early when opening a file from cmdline
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
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
      ensure_installed = system.treesitter_parsers_ensure_installed,
      install_dir = system.treesitter_install_dir,
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

      system.treesitter_parsers_installed = ts.get_installed("parsers")

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.tbl_contains(system.treesitter_parsers_installed, vim.bo[args.buf].filetype) then
            vim.treesitter.start()
          end
        end,
      })
    end,
  },
  { "calops/hmts.nvim" },
}

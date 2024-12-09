local system = require("system")
local parsers_base = { "c", "lua", "markdown", "markdown_inline", "vim", "vimdoc", "query" }
local parsers_ensure_installed = system.has_self_install and "all" or (system.is_nix and {} or parsers_base)
---@diagnostic disable-next-line: param-type-mismatch
local parsers_install_dir = vim.fs.joinpath(system.site_dir, "treesitter")

return {
  "nvim-treesitter/nvim-treesitter",
  cmd = {
    "TSBufDisable",
    "TSBufEnable",
    "TSBufToggle",
    "TSDisable",
    "TSEnable",
    "TSToggle",
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSModuleInfo",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
  event = { "BufReadPre", "BufNewFile" },
  init = function(plugin)
    -- PERF: add `nvim-treesitter` queries to the `rtp`.
    -- This is needed because bunch of plugins no longer requires it, which
    -- no longer trigger the module to be loaded in time.
    -- However, the only things that those plugins need are the custom queries,
    -- which is made available with this.
    -- Source:
    -- https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/plugins/treesitter.lua
    require("lazy.core.loader").add_to_rtp(plugin)
    pcall(require, "nvim-treesitter.query_predicates")
  end,
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = parsers_ensure_installed,
    auto_install = system.has_self_install,
    parser_install_dir = parsers_install_dir,
  },
  config = function(_, opts)
    vim.opt.runtimepath:prepend(parsers_install_dir)
    require("nvim-treesitter.configs").setup(opts)
  end,
}

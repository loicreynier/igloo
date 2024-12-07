local has_self_install = require("system").has_self_install

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
    auto_install = has_self_install,
    ensure_installed = function()
      local parsers
      if has_self_install then
        parsers = "maintained"
      else
        parsers = { "c", "lua", "markdown", "markdown_inline", "vim", "vimdoc", "query" }
      end
      return parsers
    end,
    highlight = { enable = true },
    indent = { enable = true },
  },
}

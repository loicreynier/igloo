local sinfo = vim.g.sinfo

---@module "lazy.types"
---@type LazySpec[]
return {
  -- Treesitter configuration
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
    event = { "BufReadPost", "BufNewFile", "FileType" },
    lazy = vim.fn.argc(-1) == 0,
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      auto_install = not sinfo.is_offline,
      ensure_installed = not sinfo.is_offline and "all" or {},
      install_dir = vim.fs.joinpath(vim.fs.joinpath(vim.fn.stdpath("data"), "site"), "treesitter"),
    },
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
      if not sinfo.is_slow and not sinfo.is_offline then ts.install(opts.ensure_installed) end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user.treesitter.setup", {}),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if vim.list_contains(ts.get_installed(), lang) then
            vim.treesitter.start(args.buf, lang)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            -- vim.wo.foldmethod = "expr"
            -- if Snacks then Snacks.notify(string.format("Enabling Treesitter for %s", lang)) end
          elseif vim.list_contains(ts.get_available(), lang) then
            if Snacks then Snacks.notify(string.format("Treesitter parser available for %s", lang)) end
          end
        end,
        desc = "Enable Treesitter for installed languages",
      })
    end,
  },

  -- Object selection and actions
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entier builtin `ftplugin` mappings to avoid conflicts
      vim.g.no_plugin_map = true
    end,
    keys = {
      -- Select
      {
        "am",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end,
        desc = "Select outer function",
        mode = { "x", "o" },
      },
      {
        "im",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end,
        desc = "Select inter function",
        mode = { "x", "o" },
      },
      {
        "ac",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end,
        desc = "Select outer class",
        mode = { "x", "o" },
      },
      {
        "ic",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end,
        desc = "Select inter class",
        mode = { "x", "o" },
      },
      {
        "ab",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects") end,
        desc = "Select outer block",
        mode = { "x", "o" },
      },
      {
        "ib",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects") end,
        desc = "Select inter block",
        mode = { "x", "o" },
      },
      {
        "a/",
        function() require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects") end,
        desc = "Select outer comment",
        mode = { "x", "o" },
      },
      -- Move
      {
        "]m",
        function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,
        desc = "Next function start",
        mode = { "n", "x", "o" },
      },
      {
        "]M",
        function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,
        desc = "Next function end",
        mode = { "n", "x", "o" },
      },
      {
        "[m",
        function() require("nvim-treesitter-textobjects.move").goto_prev_start("@function.outer", "textobjects") end,
        desc = "Next function start",
        mode = { "n", "x", "o" },
      },
      {
        "[M",
        function() require("nvim-treesitter-textobjects.move").goto_prev_end("@function.outer", "textobjects") end,
        desc = "Previous function start",
        mode = { "n", "x", "o" },
      },
      -- Swap
      {
        "<A-l>",
        function()
          ---@diagnostic disable-next-line: param-type-mismatch
          require("nvim-treesitter-textobjects.swap").swap_next({
            "@parameter.inner",
            "@statement.outer",
            "@function.outer",
          })
        end,
        desc = "Swap next object",
        mode = { "n" },
      },
      {
        "<A-h>",
        function()
          ---@diagnostic disable-next-line: param-type-mismatch
          require("nvim-treesitter-textobjects.swap").swap_previous({
            "@parameter.inner",
            "@statement.outer",
            "@function.outer",
          })
        end,
        desc = "Swap next object",
        mode = { "n" },
      },
    },
  },

  -- Split or join list-like constructs
  -- NOTE: https://github.com/Wansmer/treesj may be a more complete alternative
  {
    "bennypowers/splitjoin.nvim",
    cmd = { "SplitjoinJoin", "SplitjoinSplit", "SplitjoinToggle" },
    keys = {
      { "gj", function() require("splitjoin").join() end, desc = "Join the object under cursor (Splitjoin)" },
      { "g,", function() require("splitjoin").split() end, desc = "Split the object under cursor (Splitjoin)" },
      {
        "gS",
        function() require("splitjoin").toggle() end,
        desc = "Toggle join/split the object under cursor (Splitjoin)",
      },
    },
  },

  -- TODO comments highlighting
  {
    "alexmozaidze/tree-comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      keywords = {
        todo = { "TODO", "WIP" },
        note = { "NOTE", "INFO", "DOCS", "PERF", "TEST" },
        warning = { "WARN", "WARNING", "SAFETY", "HACK" },
        error = { "FIX", "FIXME", "BUG", "ERROR" },
      },
    },
  },
}

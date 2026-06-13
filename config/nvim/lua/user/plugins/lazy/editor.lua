local sinfo = require("user.system").info
local common = require("user.plugins.config.common")

---@module "lazy.types"
---@type LazySpec
return {
  -- Smart comment insertion
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- Smart visual whitespace
  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "ModeChanged *:[vV\22]", -- Lazy load when entering visual mode
    opts = {
      ignore = {
        filetypes = common.disabled_filetypes,
        buftypes = common.disabled_buftypes,
      },
    },
  },

  -- Smart indent
  {
    "NMAC427/guess-indent.nvim",
    enabled = not sinfo.is_slow,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      auto_cmd = true,
      filetype_exclude = common.disabled_filetypes,
      buftype_exclude = common.disabled_buftypes,
    },
  },
  {
    "Darazaki/indent-o-matic",
    enabled = false,
    opts = {},
  },

  -- Smart paste
  {
    "nemanjamalesija/smart-paste.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Image paste
  {
    "hakonharnes/img-clip.nvim",
    enabled = not sinfo.is_ssh,
    event = "VeryLazy",
    opts = {},
  },

  -- Smart column
  {
    "m4xshen/smartcolumn.nvim",
    enabled = false and not sinfo.is_slow,
    event = "BufEnter",
    opts = {
      disabled_filetypes = common.disabled_filetypes,
      disabled_buftypes = common.disabled_buftypes,
      colorcolumn = 100,
      editorconfig = true,
    },
  },
  {
    "hankertrix/nerd_column.nvim", -- Author says it's faster than `smartcolumn`
    enabled = not sinfo.is_slow,
    event = "BufEnter",
    ---@module "nerd_column"
    ---@type NerdColumn.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      colour_column = 100,
    },
  },

  -- Smart TODO comments & integration
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "alexmozaidze/tree-comment.nvim" },
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = function()
      local tree_comment = require("tree-comment")
      local keywords_folke, colors = tree_comment.folkify_keywords(tree_comment.get_keywords())
      -- keywords_folke.CAUTION.icon =  "☢" -- Custom group icons
      local opts = {
        keywords = keywords_folke,
        colors = colors,
        highlight = { keyword = "empty", after = "" }, -- Make it use `tree-comment` highlighting
      }
      return opts
    end,
    keys = {
      {
        "]t",
        function() require("todo-comments").jump_next() end,
        desc = "Next TODO comment",
      },
      {
        "[t",
        function() require("todo-comments").jump_prev() end,
        desc = "Previous TODO comment",
      },
    },
  },

  -- Align text interactively
  {
    "nvim-mini/mini.align",
    opts = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
    keys = {
      { "ga", mode = { "n", "v" }, desc = "Align (MiniAlign)" },
      { "gA", mode = { "n", "v" }, desc = "Align with preview (MiniAlign)" },
    },
  },
}

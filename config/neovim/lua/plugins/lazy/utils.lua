local is_slow = require("system").is_slow

local function wk_add_sessions()
  require("which-key").add({
    "<Leader>q",
    group = "Session management",
    icon = require("rice").icons.actions.sessions,
  })
end

return {
  -- Session management
  -- Persisted = Persistence fork with more features
  {
    "folke/persistence.nvim",
    enabled = is_slow,
    event = "BufReadPre",
    keys = {
      {
        "<Leader>ql",
        function() require("persistence").load() end,
        desc = "Load session (Persistence)",
      },
      {
        "<Leader>qs",
        function() require("persistence").save() end,
        desc = "Save session (Persistence)",
      },
      {
        "<Leader>qS",
        function() require("persistence").select() end,
        desc = "Select session (Persistence)",
      },
    },
    init = function() wk_add_sessions() end,
    opts = {},
  },
  {
    "olimorris/persisted.nvim",
    enabled = not is_slow,
    event = "BufReadPre",
    keys = {
      {
        "<Leader>ql",
        "<Cmd>SessionLoad<CR>",
        desc = "Load session (Persisted)",
      },
      {
        "<Leader>qs",
        "<Cmd>SessionSave<CR>",
        desc = "Save session (Persisted)",
      },
      {
        "<Leader>qS",
        function() require("telescope").extensions.persisted.persisted() end,
        desc = "Select session (Persisted)",
      },
      {
        "<Leader>qt",
        "<Cmd>SessionToggle<CR>",
        desc = "Toggle sessions saving (Persisted)",
      },
    },
    init = function() wk_add_sessions() end,
    opts = {
      autostart = true,
      autoload = false,
      use_git_branch = true,
      should_save = function()
        if vim.bo.filetype == "snacks_dashboard" then return false end
        if vim.bo.filetype == "alpha" then return false end
        if vim.bo.filetype == "" and vim.api.nvim_buf_get_name(0) == "" then return false end
        if vim.api.nvim_buf_get_name(0):match("COMMIT_EDITMSG") then return false end
        return true
      end,
      telescope = {
        mappings = {
          copy_session = "<C-r>",
        },
      },
    },
    config = function(_, opts)
      require("persisted").setup(opts)
      require("telescope").load_extension("persisted")
    end,
  },

  -- Copy with context (line numbers and file name)
  {
    "zhisme/copy_with_context.nvim",
    keys = {
      {
        "<Leader>cy",
        function() require("copy_with_context.main").copy_with_context(true, true) end,
        mode = { "n", "v" },
        desc = "Copy with context",
      },
      {
        "<Leader>cY",
        function() require("copy_with_context.main").copy_with_context(false, true) end,
        mode = { "n", "v" },
        desc = "Copy with context (relative)",
      },
    },
    opts = {},
  },
}

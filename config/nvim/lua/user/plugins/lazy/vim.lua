---@brief
---
--- Plugins related to Vim features (modal editing, motions, registers)
---

---@module "lazy.types"
---@type LazySpec
return {
  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    ---@module "better_escape"
    ---@type BetterEscapeSettings
    opts = {
      timeout = 300,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
        t = { k = { j = "<C-\\><C-n>" } },
      },
    },
  },

  -- Navigation hints
  {
    "tris203/precognition.nvim",
    dependencies = { "chrisgrieser/nvim-spider" }, -- Spider aware precognition
    ---@module "precognition"
    ---@type Precognition.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      startVisible = false,
      disable_fts = require("user.plugins.config.common").disabled_filetypes,
    },
    keys = {
      { "<Leader>up", "<cmd>Precognition peek<CR>", { desc = "Show navigation hint (Precognition)" } },
      {
        "<Leader>uP",
        "<Cmd>Precognition toggle<CR>",
        { desc = "Toggle navigation hints (Precognition)" },
      },
    },
  },
  {
    "tris203/precognition.nvim",
    opts = function()
      if Snacks then
        local preco = require("precognition")
        Snacks.toggle({
          name = "Navigation hints (Precognition)",
          get = preco.is_visible,
          set = function(state)
            if state then
              preco.show()
            else
              preco.hide()
            end
          end,
        }):map("<Leader>uP")
      end
    end,
  },

  -- Move like a spider: `camelCase` & `SNAKE_CASE` aware and skip unsignifiant punctuation
  {
    "chrisgrieser/nvim-spider",
    ---@module "spider"
    ---@type Spider.config
    opts = {
      subwordMovement = true,
      skipInsignificantPunctuation = false,
    },
    keys = {
      {
        "w",
        function() require("spider").motion("w") end,
        desc = "Spider-w",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        function() require("spider").motion("e") end,
        desc = "Spider-e",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        function() require("spider").motion("b") end,
        desc = "Spider-b",
        mode = { "n", "o", "x" },
      },
      {
        "ge",
        function() require("spider").motion("ge") end,
        desc = "Spider-ge",
        mode = { "n", "o", "x" },
      },
    },
  },

  -- Yanklock
  {
    "daltongd/yanklock.nvim",
    opts = {
      notify = false,
    },
    keys = {
      {
        "<Leader>Y",
        function() require("yanklock").toggle() end,
        desc = "Toggle yank register lock (yanklock)",
      },
    },
  },
  {
    "daltongd/yanklock.nvim",
    opts = function()
      if Snacks then
        local lock = require("yanklock")
        Snacks.toggle({
          name = "yank register lock (yanklock)",
          get = function() return lock._state.lock end,
          set = function(state)
            if state then
              lock.lock()
            else
              lock.unlock()
            end
          end,
        }):map("<Leader>yl")
      end
    end,
  },
}

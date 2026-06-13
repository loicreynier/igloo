local icons = require("user.rice").icons

---@module "lazy"
---@type LazySpec[]
return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    cond = vim.fn.executable("opencode") == 1,
    dependencies = {
      {
        ---@module "snacks"
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<Leader>oa",
        function() require("opencode").ask("@this: ", { submit = true }) end,
        desc = "Ask OpenCode...",
        mode = { "n", "x" },
      },
      {
        "<Leader>ox",
        function() require("opencode").select() end,
        desc = "Select OpenCode action...",
        mode = { "n", "x" },
      },
      {
        "<Leader>oT",
        function() require("opencode").toggle() end,
        desc = "Toggle Opencode",
        mode = { "n", "t" },
      },
      {
        "go",
        function() return require("opencode").operator("@this ") end,
        desc = "Add range to Opencode",
        mode = { "n", "x" },
        expr = true,
      },
      {
        "goo",
        function() return require("opencode").operator("@this ") .. "_" end,
        desc = "Add line to Opencode",
        expr = true,
      },
      {
        "<Leader>os",
        function() require("opencode").select_session() end,
        desc = "Select OpenCode session",
      },
      {
        "<Leader>on",
        function() require("opencode").command("session.new") end,
        desc = "New OpenCode session",
      },
      {
        "<Leader>oi",
        function() require("opencode").command("session.interrupt") end,
        desc = "Interrupt OpenCode",
      },
    },
    init = function()
      require("which-key").add({
        { "<Leader>o", group = "OpenCode", icon = icons.plugins.Opencode },
      })
    end,
    config = function() vim.g.opencode_opts = {} end,
  },
}

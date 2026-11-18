local icons = require("user.rice").icons

local opencode_cmd = "opencode"
---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  win = {
    position = "right",
    enter = false,
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function() require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts) end,
  },
}

---@module "lazy"
---@type LazySpec[]
return {
  {
    "nickjvandyke/opencode.nvim",
    cond = vim.fn.executable(opencode_cmd) == 1,
    dependencies = {
      {
        ---@module "snacks"
        "folke/snacks.nvim",
        opts = {
          input = { enabled = true },
          picker = {
            enabled = true,
            actions = {
              opencode_send = function(picker) ---@param picker snacks.Picker
                local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
                  return item.file
                      and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                    or item.text
                end, picker:selected({ fallback = true }))

                require("opencode").prompt(table.concat(items, ", ") .. " ")
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
          terminal = { enabled = true },
        },
      },
    },
    keys = {
      {
        "<Leader>oa",
        function() require("opencode").ask("@this: ") end,
        desc = "Ask OpenCode",
        mode = { "n", "x" },
      },
      {
        "<Leader>ox",
        function() require("opencode").select() end,
        desc = "Select OpenCode action",
        mode = { "n", "x" },
      },
      {
        "<Leader>ot",
        function() require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts) end,
        desc = "Toggle OpenCode",
        mode = { "n", "t" },
      },
    },
    init = function()
      require("which-key").add({
        { "<Leader>o", group = "OpenCode", icon = icons.plugins.Opencode },
      })
    end,
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {}
    end,
  },
}

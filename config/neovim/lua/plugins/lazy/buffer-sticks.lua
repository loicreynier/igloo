---@type LazySpec
return {
  "ahkohd/buffer-sticks.nvim",
  event = "VeryLazy",
  config = function()
    local sticks = require("buffer-sticks")
    sticks.setup({
      filter = { buftypes = { "terminal" } },
      highlights = {
        active = { link = "Statement" },
        alternate = { link = "StorageClass" },
        inactive = { link = "Whitespace" },
        active_modified = { link = "Constant" },
        alternate_modified = { link = "Constant" },
        inactive_modified = { link = "Constant" },
        label = { link = "Comment" },
      },
    })

    Snacks.toggle.new({
      id = "buffer_sticks",
      name = "Toggle buffer sticks",
      get = function() return sticks.is_visible() end,
      set = function() return sticks.toggle() end,
    })

    vim.api.nvim_create_user_command(
      "BufferSticksToggle",
      ---@diagnostic disable-next-line: undefined-field
      function() Snacks.toggle.toggles.buffer_sticks:toggle() end,
      {}
    )
  end,
}

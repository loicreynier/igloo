return {
  "folke/zen-mode.nvim",
  dependencies = { "folke/twilight.nvim" },
  cmd = { "ZenMode" },
  keys = { { "<Leader>uz", "<Cmd>ZenMode<CR>", desc = "Toggle zen mode" } },
  opts = {
    window = {
      backdrop = 0.95,
      width = 0.60,
      height = 1,
    },
    plugins = {
      twilight = { enabled = false },
      gitsigns = { enabled = true },
      wezterm = { enabled = true, font = "+4" },
    },
  },
}

return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  event = "BufReadPost",
  init = function()
    vim.keymap.set("n", "<Leader>gd", function()
      if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
      else
        vim.cmd("DiffviewClose")
      end
    end, { desc = "Toggle Diffview", silent = true })
  end,
  opts = {
    use_icons = true,
  },
}

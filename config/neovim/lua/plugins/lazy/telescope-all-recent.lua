---@type LazySpec
return {
  "prochri/telescope-all-recent.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    {
      "kkharji/sqlite.lua",
      config = function()
        if require("system").is_nix and os.getenv("NVIM_NIX_SQLITE_PATH") then
          vim.g.sqlite_clib_path = os.getenv("NVIM_NIX_SQLITE_PATH")
        end
      end,
    },
    "stevearc/dressing.nvim",
  },
  opts = {
    database = {
      folder = vim.fn.stdpath("state"),
    },
  },
}

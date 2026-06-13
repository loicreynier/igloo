---@module "lazy.types"
---@type LazySpec[]
return {
  -- Improved UI & better workflow
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}

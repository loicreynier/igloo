local enabled = vim.g.plugins_extra

---@module "lazy"
---@type LazySpec[]
return {
  {
    "axsaucedo/neovim-power-mode",
    enabled = enabled,
    cmd = { "PowerModeToggle", "PowerModeEnable" },
    opts = {},
  },
}

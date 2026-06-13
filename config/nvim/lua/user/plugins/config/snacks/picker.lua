---@module "snacks"
---@type snacks.picker.Config
return {
  enabled = true,
  db = {
    sqlite3_path = vim.g.sqlite_clib_path,
  },
  win = {
    input = {
      keys = {
        -- Don't override Emacs-like insert mode motions
        ["<C-u>"] = { "list_scroll_up", mode = { "n" } },
        ["<C-d>"] = { "list_scroll_down", mode = { "n" } },
        ["<A-u>"] = "preview_scroll_up",
        ["<A-d>"] = "preview_scroll_up",
      },
    },
  },
}

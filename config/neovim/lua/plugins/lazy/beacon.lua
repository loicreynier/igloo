---@type LazySpec
return {
  "DanilaMihailov/beacon.nvim",
  enabled = not require("system").is_slow,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    cursor_events = { "CursorMoved" },
    window_events = { "WinEnter", "FocusGained" },
  },
}

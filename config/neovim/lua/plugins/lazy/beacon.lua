return {
  "DanilaMihailov/beacon.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    cursor_events = { "CursorMoved" },
    window_events = { "WinEnter", "FocusGained" },
  },
}

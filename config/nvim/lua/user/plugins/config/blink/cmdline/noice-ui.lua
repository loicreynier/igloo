local M = {}

-- HACK: make the menu blend with Noice's command line popup menu. Inspired by:
-- https://github.com/b0o/dotfiles/blob/main/config/nvim/lua/user/plugins/completion.lua
function M.setup()
  local group = vim.api.nvim_create_augroup("user.blink.cmdline.noice-ui", { clear = true })
  local menu_border_bak = nil
  local menu_highlight_bak = nil

  vim.api.nvim_create_autocmd("CmdLineEnter", {
    group = group,
    callback = function(event)
      local win = require("blink.cmp.completion.windows.menu").win
      menu_border_bak = win.config.border
      menu_highlight_bak = win.config.winhighlight
      if event.match == ":" then
        win.config.winhighlight =
          -- `blink.cmp` default with Noice backgrounds on the first 2 elements
          "Normal:NoiceCmdline,FloatBorder:NoiceCmdlinePopupBorder,CursorLine:BlinkCmpMenuSelection,Search:None"
        win.config.border = {
          "┐",
          " ",
          "┌",
          "│",
          "╯",
          "─",
          "╰",
          "│",
        }
      end
    end,
  })

  vim.api.nvim_create_autocmd("CmdLineLeave", {
    group = group,
    callback = function()
      if menu_border_bak then
        local win = require("blink.cmp.completion.windows.menu").win
        win.config.border = menu_border_bak
        win.config.winhighlight = menu_highlight_bak
        menu_border_bak = nil
        menu_highlight_bak = nil
      end
    end,
  })
end

return M

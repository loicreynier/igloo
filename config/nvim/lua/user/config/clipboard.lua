local sinfo = require("user.system").info

vim.schedule(function()
  if sinfo.is_wsl then
    vim.g.clipboard = {
      name = "WSLClipboard",
      copy = {
        ["+"] = "win32yank.exe -i",
      },
      paste = {
        ["+"] = "win32yank.exe -o --lf",
      },
      cache_enabled = 0,
    }
  elseif sinfo.is_ssh and vim.fn.executable("rsclip") == 1 and os.getenv("DISPLAY") then
    vim.g.clipboard = {
      name = "SSHClipboard_rsclip",
      copy = {
        ["+"] = "rsclip",
      },
      paste = {
        ["+"] = "rsclip -p",
      },
    }
  end
end)

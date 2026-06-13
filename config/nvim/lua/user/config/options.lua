local opt = vim.opt
local sinfo = require("user.system").info

-- UI --------------------------------------------------------------------------

opt.mouse = "nv"
opt.title = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = not sinfo.is_slow
opt.foldmethod = "marker"
opt.showmatch = true
opt.splitright = true
opt.splitbelow = true
opt.equalalways = true
opt.laststatus = 3
opt.list = true
opt.listchars = {
  tab = "»·",
  extends = "⟩",
  precedes = "⟨",
  trail = "·",
  nbsp = "␣",
  -- eol = "↲",
}
opt.fillchars:append({ diff = "╱" })
opt.inccommand = "split"

opt.winborder = "rounded"

-- GUI -------------------------------------------------------------------------

opt.termguicolors = true

-- Indentation -----------------------------------------------------------------

opt.smarttab = true
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
vim.g.netrw_home = vim.fn.stdpath("state")

-- Search ----------------------------------------------------------------------

opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

-- Completion ------------------------------------------------------------------

vim.opt.completeopt = {
  "menu",
  "menuone",
  "noinsert",
  "fuzzy",
  "popup",
}

-- Memory ----------------------------------------------------------------------

opt.hidden = true
opt.history = 100
opt.lazyredraw = false
opt.autowrite = true
opt.swapfile = true
opt.backup = false
opt.undofile = true

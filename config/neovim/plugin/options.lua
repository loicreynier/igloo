local opt = vim.opt
local system = require("system")

-- # UI
opt.mouse = "nv"
opt.title = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = not system.is_slow
opt.foldmethod = "marker"
opt.showmatch = true
opt.splitright = true
opt.splitbelow = true
opt.showmode = false
opt.laststatus = 2
opt.equalalways = true
opt.list = true
opt.listchars = {
  tab = "»·",
  extends = "⟩",
  precedes = "⟨",
  trail = "·",
  nbsp = "␣",
  -- eol = "↲",
}
opt.inccommand = "split"

-- # GUI
opt.termguicolors = true

-- # Indentation
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = true

-- # Search
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

-- # Completion
opt.completeopt = {
  "menuone",
  "noselect",
  "noinsert",
}
opt.pumheight = 10
opt.wildoptions = {
  "pum",
}
opt.wildmode = {
  "longest:full",
  "full",
}
opt.wildignore = {
  "__pycache__",
  "*pycache*",
  "*.pyc",
  "*.o",
}
if vim.fn.has("nvim-0.11") == 1 then
  vim.opt.completeopt:append("fuzzy")
  vim.opt.wildoptions:append("fuzzy")
end

-- # Memory
opt.hidden = true
opt.history = 100
opt.lazyredraw = false
opt.autowrite = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
vim.g.netrw_home = vim.fn.stdpath("state") .. "/nvim"

-- # Environment

opt.exrc = true

if vim.fn.executable("rg") == 1 then opt.grepprg = "rg --vimgrep" end

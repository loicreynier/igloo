local opt = vim.opt

-- # UI
opt.mouse = "nv"
opt.title = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = true
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
pumheight = 10;
wildoptions = "pum";
wildmode = {
  "longest",
  "full",
}
wildignore = {
  "__pycache__",
  "*pycache*",
  "*.pyc",
  "*.o",
}

-- # Memory
opt.hidden = true
opt.history = 100
opt.lazyredraw = false
opt.autowrite = true
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- # Environment

opt.exrc = true

if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep"
end

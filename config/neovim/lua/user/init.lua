-- # System recognition from environment variables -------------------------------------------------
vim.g.system = os.getenv("SYSTEM") or "unknown"

local system_options = os.getenv("SYSTEM_OPTIONS") or ""
local options_list = {}
for option in string.gmatch(system_options, "([^:]+)") do
  table.insert(options_list, option)
end
vim.g.system_options = options_list

local system = vim.g.system

-- # Configuraiton - Base options ------------------------------------------------------------------

-- ## UI
vim.o.mouse = "nv"
vim.o.title = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.foldmethod = "marker"
vim.o.showmatch = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.showmode = false
vim.o.laststatus = 2
vim.o.equalalways = true
vim.o.list = true
vim.opt.listchars = {
  tab = "»·",
  extends = "⟩",
  precedes = "⟨",
  trail = "·",
  nbsp = "␣",
  -- eol = "↲",
}

-- ## GUI
vim.o.termguicolors = true

-- ## Indentation
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wrap = true

-- ## Search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- ## Completion
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

-- ## Memory
vim.o.hidden = true
vim.o.history = 100
vim.o.lazyredraw = false
vim.o.autowrite = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

-- ## Environment

vim.o.exrc = true

if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep"
end

-- # Configuraiton - Base keybindings --------------------------------------------------------------

vim.g.mapleader = " " -- Love having a map leader accessible from both hands, sorry comma

vim.keymap.set({"i", "c"}, "jj", "<Esc>")
vim.keymap.set("t", "kj", "<C-\\><C-n>")
vim.keymap.set("i", "<C-c>", "<Esc>")

-- ## Yanking, pasting & register stuff
vim.keymap.set({"n", "v",}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+yg_]]) -- Last visual selection
vim.keymap.set("n", "<leader>yy", [["+yy]]) -- Entire line
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])
vim.keymap.set({"n", "v"}, "<leader>P", [["+P]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]]) -- Embrace the void

-- ## Completion & wildmenu
vim.keymap.set({"i", "c", "t"}, "<C-o>", "<S-Tab>")

vim.keymap.set("c", "<C-p>", function()
  return vim.fn.wildmenumode() == 1 and "<Left>" or "<Up>"
end, { expr = true })

vim.keymap.set("c", "<C-n>", function()
  return vim.fn.wildmenumode() == 1 and "<Right>" or "<Down>"
end, { expr = true })

-- ## Insert mode Emacs-like motions
vim.keymap.set({"i", "c", "t"}, "<C-a>", "<Home>", {desc = "Beginning of line"})
vim.keymap.set({"i", "c", "t"}, "<C-e>", "<End>", {desc = "End of line"})
vim.keymap.set({"i", "c", "t"}, "<C-f>", "<Right>", {desc = "Move forward"})
vim.keymap.set({"i", "c", "t"}, "<C-b>", "<Left>", {desc = "Move backward"})

-- # Configuraiton - Filetypes ---------------------------------------------------------------------

vim.filetype.add({
  extension = {
    bbcode = "bbcode",
    cuf = "fortran",
    dig = "fortran", -- DYJEAT input file
  },
  filename = {
    [".envrc"] = "sh",
    [".ecrc"] = "json",
    [".yamllint"] = "yaml",
  },
  pattern = {
    ["%.env%..*"] = "sh",
  }
})

-- # Plugin load -----------------------------------------------------------------------------------

require("user.lazy")

-- # Configuration - Python host setup -------------------------------------------------------------

vim.notify = require("notify")

local function set_python_host_prog(path)
  if vim.fn.filereadable(path) == 1 then
    vim.g.python3_host_prog = path
  else
    vim.notify(
    "Python host path not found: '" .. path .. "'",
    "warn",
    {title = "Python setup"}
    )
  end
end

if system == "ONERA_workstation" then
  set_python_host_prog("/opt/tools/python/3.12.2-gnu850/bin/python3")
else
  vim.notify(
  "Unknown system. Please set `g:python3_host_prog` manually",
  "warn",
  {title = "Python setup"}
  )
end

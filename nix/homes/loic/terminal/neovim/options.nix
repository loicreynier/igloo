{
  config,
  lib,
  ...
}: {
  programs.nixvim = {
    opts = {
      # -- UI
      mouse = "nv";
      title = true;
      number = true;
      relativenumber = true;
      cursorline = true;
      cursorcolumn = true;
      foldmethod = lib.mkDefault "marker";
      showmatch = true;
      laststatus = 2;
      showmode = false;
      splitright = true;
      splitbelow = true;
      equalalways = true;
      list = true;
      listchars = {
        tab = "»·";
        extends = "⟩";
        precedes = "⟨";
        trail = "·";
        nbsp = "_";
        # eol = "↲";
      };
      clipboard = "unnamedplus";

      # -- GUI
      termguicolors = true;

      # -- Indentation
      expandtab = true;
      smarttab = true;
      autoindent = true;
      smartindent = true;
      wrap = true;

      # -- Search
      hlsearch = false;
      ignorecase = true;
      smartcase = true;

      # -- Completion
      pumheight = 10;
      wildoptions = "pum";
      wildmode = [
        "longest"
        "full"
      ];
      wildignore = [
        "__pycache__"
        "*pycache*"
        "*.pyc"
        "*.o"
      ];

      # -- Memory
      hidden = true;
      history = 100;
      lazyredraw = false;
      autowrite = true;
      swapfile = false;
      backup = false;
      undofile = true;

      # -- Environment
      exrc = true;
    };
  };
}

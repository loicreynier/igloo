{lib, ...}: {
  programs.nixvim = {
    globals.mapleader = ",";

    keymaps = [
      # -- Basic remapping
      {
        action = "<Esc>";
        key = "jj";
        mode = ["i" "c"];
      }
      {
        action = "<home>";
        key = "<c-a>";
        mode = ["i" "c"];
      }
      {
        action = "<End>";
        key = "<c-e>";
        mode = ["i" "c"];
      }
      {
        action = "<right>";
        key = "<C-f>";
        mode = ["i" "c"];
      }
      {
        action = "<left>";
        key = "<C-b>";
        mode = ["i" "c"];
      }
      {
        action = "<S-Tab>";
        key = "<C-o>";
        mode = ["i" "c"];
      }

      # -- Telescope
      {
        action = ":Telescope<CR>";
        key = "<C-k>";
        mode = ["n"];
      }

      # -- Trouble
      {
        action = ":TroubleToggle<CR>";
        key = "<Leader>lT";
        mode = ["n"];
      }

      # -- `duck.nvim`
      {
        action.__raw = "function() require('duck').hatch() end";
        key = "<Leader>dd";
        options.desc = "Spawn a little duck, coin coin";
        mode = ["n"];
      }
      {
        action.__raw = "function() require('duck').cook() end";
        key = "<Leader>dk";
        options.desc = "Despawn a little duck, coin coin";
        mode = ["n"];
      }
    ];

    extraConfigVim = ''
      ${lib.strings.fileContents ./keybindings.vim}
    '';
  };
}

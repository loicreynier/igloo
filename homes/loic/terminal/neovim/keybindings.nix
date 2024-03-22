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

      # -- Trouble
      {
        action = ":TroubleToggle<CR>";
        key = "<Leader>lT";
        mode = ["n"];
      }

      # -- `duck.nvim`
      {
        action = "function() require('duck').hatch() end";
        lua = true;
        key = "<Leader>dd";
        options.desc = "Spawn a little duck, coin coin";
        mode = ["n"];
      }
      {
        action = "function() require('duck').cook() end";
        lua = true;
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

{
  imports = [
    ./autocmd.nix
    ./options.nix
    ./plugins.nix
    ./keybindings.nix
  ];

  programs.nixvim = {
    enable = true;
    enableMan = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    filetype = {
      extension = {
        cuf = "fortran";
        bbcode = "bbcode";
        cuf = "fortran";
      };
      filename = {
        ".ecrc" = "json";
      };
    };
  };
}

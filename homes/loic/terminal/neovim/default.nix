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
  };
}

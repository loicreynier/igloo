{
  config,
  lib,
  pkgs,
  ...
}: {
  environment = {
    defaultPackages = lib.mkForce [];

    systemPackages = with pkgs; [
      curl
      git
      ripgrep
      rsync
      vim
      wget
    ];
  };

  programs = {
    comma.enable = true;
    less.enable = true;
    starship.enable = true;
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv = {
      enable = true;
      # In case alternative `nix` package is used, such as `nix-super`
      package = pkgs.nix-direnv.override {
        nix = config.nix.package;
      };
    };
    loadInNixShell = true;
    direnvrcExtra = builtins.readFile (pkgs.substituteAll {
      src = ./direnvrc.sh;
      sha1sum = "${pkgs.perl}/bin/shasum";
    });
  };
}

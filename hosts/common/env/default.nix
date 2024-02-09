{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

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
    less.enable = true;
    starship.enable = true;
  };

  programs = {
    command-not-found.enable = lib.mkForce false;
    nix-index-database.comma.enable = true;
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
      src = ../../../config/direnv/direnvrc.sh;
      sha1sum = "${pkgs.perl}/bin/shasum";
    });
  };
}

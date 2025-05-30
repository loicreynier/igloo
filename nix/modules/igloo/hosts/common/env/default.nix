{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  environment = {
    defaultPackages = lib.mkForce [ ];

    systemPackages =
      with pkgs;
      [
        curl
        file
        git
        gnutar
        ripgrep
        rsync
        vim
        wget
        zip
        unzip
      ]
      ++ lib.optionals (config.igloo.device.gpu.type == "nvidia") [
        nvitop
      ];
  };

  environment.sessionVariables = {
    IGLOO = self; # Should I use the writable (Git repo) location instead?
    NH_FLAKE = self; # Some tooling use this variable, e.g. `nh`
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
    direnvrcExtra = lib.fileContents (
      pkgs.replaceVars "${self}/config/direnv/direnvrc.sh" { sha1sum = "${pkgs.perl}/bin/shasum"; }
    );
  };

  programs.nano =
    let
      nanoConf = lib.strings.fileContents "${self}/config/nano/nanorc";
    in
    {
      enable = true;
      nanorc = ''
        include ${pkgs.nanorc}/share/*.nanorc # Extended syntax highlighting

        ${nanoConf}
      '';
    };
}

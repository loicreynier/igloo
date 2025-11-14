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
    inputs.noshell.nixosModules.default
  ];

  users.users.root.shell = pkgs.bashInteractive;
  programs.noshell.enable = true;
  # Allows HM users to configure their shell with
  # xdg.configFile."shell".source = lib.getExe pkgs.nushell;

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

        kmon
      ]
      ++ lib.optionals (config.igloo.device.gpu.type == "nvidia") [
        nvitop
      ];
  };

  programs = {
    less.enable = true;
    starship.enable = true;
    command-not-found.enable = lib.mkForce false;
    nix-index-database.comma.enable = true;

    direnv = {
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

    nano =
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
  };
}

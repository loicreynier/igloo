{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.igloo.wsl;
in {
  options.igloo.wsl = {
    enable = mkEnableOption "WSL home integration";
  };

  imports = [
    ./wclip.nix
    ./vscode-server.nix
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      browserpass
    ];

    services.gpg-agent = {
      # TODO: replace with `pinentry-wsl`
      # Currently `pinentry-wsl-ps1` does not support WSL 2 with systemd.
      # pinentryFlavor = null;
      # extraConfig = ''
      #   pinentry-program "${pkgs.pinentry-wsl-ps1}/bin/pinentry-wsl-ps1"
      # '';
      pinentryPackage = pkgs.pinentry-gtk2;
    };
  };
}

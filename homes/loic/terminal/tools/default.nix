{
  config,
  pkgs,
  self,
  ...
}: let
  rgConfigPath = "${config.xdg.configHome}/ripgreprc";
  rgConfigSrc = "${self}/config/ripgrep/ripgreprc";
in {
  imports = [
    ./git.nix
    ./gpg.nix
    ./pass.nix
    ./pet.nix
    ./pubs.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    # -- Modern core utils
    just
    ripgrep
    ripgrep-all
    sd

    # -- TUIS
    du-dust
    glow

    # -- Text processing
    grex
    xsv

    # -- Media processing tools
    exiftool
    ffmpeg
    libwebp
    pdftk

    # -- Networking
    wormhole-rs

    # -- Custom scripts
    x2y
    rnm
  ];

  home = {
    # -- ripgrep
    file."${rgConfigPath}".source = rgConfigSrc;
    sessionVariables."RIPGREP_CONFIG_PATH" = rgConfigPath;

    # -- Just
    shellAliases = {
      j = "just";
      ji = "just --choose";
    };
  };

  programs = {
    fd = {
      enable = true;
      extraOptions = [
        "--hidden" # Can be ignored with `--no-hidden`
        "--follow" # Always descend into symlinked dir, useful in Nix & ignored with `--no-follow`
      ];
    };
  };
}

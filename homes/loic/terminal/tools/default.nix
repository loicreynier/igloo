{
  config,
  lib,
  pkgs,
  ...
}: let
  rgConfigPath = "${config.xdg.configHome}/ripgrep/ripgreprc";
  rgConfigSrc = ../../../../config/ripgrep/ripgreprc;
in {
  imports = [
    ./git.nix
    ./gpg.nix
    ./pass.nix
    ./pet.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    # -- Modern core utils
    fd
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
  ];

  # -- ripgrep
  home = {
    file."${rgConfigPath}".text = lib.strings.fileContents rgConfigSrc;
    sessionVariables."RIPGREP_CONFIG_PATH" = rgConfigPath;
  };
}

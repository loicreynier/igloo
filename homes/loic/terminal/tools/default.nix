{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  rgConfigPath = "${config.xdg.configHome}/ripgreprc";
  rgConfigSrc = "${self}/config/ripgrep/ripgreprc";
  rnm =
    pkgs.writeShellScriptBin "rnm"
    (builtins.replaceStrings ["#!/usr/bin/env bash\n"] [""]
      (lib.fileContents "${self}/bin/rnm"));
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

    # -- Networking
    wormhole-rs

    # -- Custom scripts
    rnm
  ];

  # -- ripgrep
  home = {
    file."${rgConfigPath}".source = rgConfigSrc;
    sessionVariables."RIPGREP_CONFIG_PATH" = rgConfigPath;
  };
}

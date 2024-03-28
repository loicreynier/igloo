{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  rgConfigPath = "${config.xdg.configHome}/ripgrep/ripgreprc";
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

    # -- Networking
    wormhole-rs

    # -- Custom scripts
    rnm
  ];

  # -- ripgrep
  home = {
    file."${rgConfigPath}".text = lib.strings.fileContents rgConfigSrc;
    sessionVariables."RIPGREP_CONFIG_PATH" = rgConfigPath;
  };
}

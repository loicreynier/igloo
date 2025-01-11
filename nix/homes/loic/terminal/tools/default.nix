{
  config,
  pkgs,
  self,
  ...
}:
let
  rgConfigPath = "${config.xdg.configHome}/ripgreprc";
  rgConfigSrc = "${self}/config/ripgrep/ripgreprc";
in
{
  imports = [
    ./git.nix
    ./gpg.nix
    ./pass.nix
    ./pet.nix
    ./pubs.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    coreutils
    file

    # -- Modern core utils
    just
    ripgrep
    ripgrep-all
    sd

    # -- File manipulation
    trashy
    ouch

    # -- Process manipulation
    killall
    viddy

    # -- TUIS
    du-dust
    duf
    fx
    glow
    sysz

    # -- Text processing
    dos2unix
    jc
    jq
    grex
    xsv
    yq

    # -- Media processing tools
    exiftool
    ffmpeg
    libwebp
    imagemagick
    pdftk
    poppler_utils

    # -- Networking
    wormhole-rs

    # -- Custom scripts
    x2y
    rnm

    # -- Fetching
    neofetch
    onefetch

    # -- Memes
    sl
    uwufetch
    uwuify

    # -- Misc
    when-cli
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
    # -- `fd`
    fd = {
      enable = true;
      extraOptions = [
        "--hidden" # Can be ignored with `--no-hidden`
        "--follow" # Always descend into symlinked dir, useful in Nix & ignored with `--no-follow`
      ];
    };
  };

  services = {
    # -- `pueue`
    pueue = {
      enable = true;
      settings = {
        client = {
          dark_mode = true;
          show_expanded_aliases = true;
          show_confirmation_questions = true;
        };
      };
    };
  };
}

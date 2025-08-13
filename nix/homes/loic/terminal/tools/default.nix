{
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./git.nix
    ./gpg.nix
    ./pass.nix
    ./pubs.nix
    ./ssh.nix
  ];

  home.packages = with pkgs; [
    coreutils
    file

    # -- Modern core utils
    fd
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
    xan
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

  xdg.configFile = {
    "ripgreprc".source = "${self}/config/ripgrep/ripgreprc";
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

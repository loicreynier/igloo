{pkgs, ...}: {
  imports = [
    ./git.nix
    ./gpg.nix
    ./pass.nix
    #./ssh.nix
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
}

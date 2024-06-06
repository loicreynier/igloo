{
  lib,
  pkgs,
  ...
}: {
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    # TODO: add variations depending on system
    pinentryPackage = lib.mkDefault pkgs.pinentry-curses;
  };
}

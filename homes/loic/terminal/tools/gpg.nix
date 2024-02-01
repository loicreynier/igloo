{lib, ...}: {
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    # TODO: add variations depending on system
    pinentryFlavor = lib.mkDefault "curses";
  };
}

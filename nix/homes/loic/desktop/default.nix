{ pkgs, ... }:
let
  cursorTheme = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 16;
  };
  fileChooserDefaults = {
    date-format = "regular";
    location-mode = "path-bar";
    show-hidden = false;
    show-size-column = true;
    show-type-column = true;
    sort-column = "name";
    sort-directories-first = true;
    sort-order = "ascending";
    type-format = "category";
  };
in
{
  imports = [
    ./gnome.nix
  ];

  programs = {
    firefox = {
      enable = true;
    };

    password-store = {
      package = pkgs.pass.override {
        x11Support = true;
        waylandSupport = true;
      };
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };

  home = {
    packages = with pkgs; [
      # -- System
      wl-clipboard
      parsec-bin
      lan-mouse

      # -- Messaging
      discord
      thunderbird

      # -- Coding
      vscodium-fhs

      # -- Documents
      libreoffice
      pdfarranger
      pympress

      # -- Music
      # spotify
      spotify-adblock
      picard

      # -- Pictures
      gimp

      # -- Data
      qbittorrent
      meld

      # -- Nix
      dconf2nix
    ];

    pointerCursor = cursorTheme // {
      x11.enable = true;
      gtk.enable = true;
    };
  };

  gtk.enable = true;

  dconf.settings = {
    "org/gtk/gtk4/settings/file-chooser" = fileChooserDefaults // { };
    "org/gtk/settings/file-chooser" = fileChooserDefaults // { };
  };
}

{ pkgs, ... }:
let
  cursorTheme = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 20;
  };
in
{
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
      discord
      spotify-adblock
      thunderbird

      libreoffice
      meld
      pdfarranger
      picard
      pympress
    ];

    # Disable `adw-gtk3` for GTK 4 apps, see `gtk.theme.name` and `xdg.configFile."gtk-4.0/gtk.css"`
    file.".config/gtk-4.0/gtk.css".text = '''';

    pointerCursor = cursorTheme;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    inherit cursorTheme;
  };

  # Disable `adw-gtk3` for GTK 4 apps
  xdg.configFile."gtk-4.0/gtk.css".enable = false;
}

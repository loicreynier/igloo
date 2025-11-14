{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    gnomeExtensions.paperwm
    gnomeExtensions.just-perfection
    gnomeExtensions.burn-my-windows

    adwsteamgtk
    addwater

    eyedropper
    tagger

    dissent
  ];

  gtk = {
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };

  # Disable `adw-gtk3` for GTK 4 apps
  home.file.".config/gtk-4.0/gtk.css".text = '''';
  xdg.configFile."gtk-4.0/gtk.css".enable = false;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-key-theme = "Emacs";
      show-battery-percentage = true;
      clock-show-seconds = false;
      clock-show-weekday = true;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/desktop/search-providers" = {
      sort-order = [
        "org.gnome.Nautilus.desktop"
        "org.gnome.Documents.desktop"
      ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      click-method = "fingers"; # Two-fingers for secondary click
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "thunderbird.desktop"
        "discord.desktop"
      ];

      enabled-extensions = [
        "paperwm@paperwm.github.com"
        "burn-my-windows@schneegans.github.com"
      ];
    };

    "org/gnome/shell/extensions/paperwm" = {
      default-focus-mode = 2;
      open-window-position = 0;
      horizontal-margin = 16;
      vertical-margin = 16;
      vertical-margin-bottom = 16;
      window-gap = 16;
      selection-border-radius-top = 4;
      selection-border-size = 4;
      only-scratch-in-overview = false;
      disable-scratch-in-overview = false;
      show-workspace-indicator = false;
      show-window-position-bar = false;
      show-focus-mode-icon = false;
      show-open-position-icon = false;
      restore-workspaces-only-on-primary = "";
    };
    "org/gnome/shell/extensions/paperwm/keybindings" = {
      close-window = [ "<Super>q" ];
      new-window = [ "<Super>Return" ];
      switch-down = [
        "<Super>Down"
        "<Super>j"
      ];
      switch-left = [
        "<Super>Left"
        "<Super>h"
      ];
      switch-next = [ "<Super>n" ];
      switch-previous = [ "<Super>p" ];
      switch-right = [
        "<Super>Right"
        "<Super>l"
      ];
      switch-up = [
        "<Super>Up"
        "<Super>k"
      ];
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  # -- X configuration
  services = {
    xserver = {
      enable = lib.mkDefault true;
      excludePackages = [pkgs.xterm];
      desktopManager.gnome.enable = lib.mkDefault true;
      displayManager.gdm.enable = lib.mkDefault true;
    };
  };

  # -- GNOME configuration
  # Remove default GNOME applications
  # Sources:
  # - https://discourse.nixos.org/t/howto-disable-most-gnome-default-applications-and-what-they-are
  # - https://discourse.nixos.org/t/nixos-gnome-remove-xterm-tour-and-manual
  environment.gnome.excludePackages = with pkgs; [
    geary
    # seahorse # TODO: `gpt-agent` pinentry without Seahorse
    totem
    yelp

    gnome-connections
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
  ];

  # -- Programs
  programs.firefox.enable = true;

  environment.systemPackages = let
    gnomeEnabled = config.services.xserver.desktopManager.gnome.enable;
  in
    with pkgs;
      [
        vlc
      ]
      ++ lib.optionals gnomeEnabled [
        celluloid
        warp
      ];

  # -- Fonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "DroidSansMono"
          "FiraCode"
          "SourceCodePro"
        ];
      })
    ];
  };
}

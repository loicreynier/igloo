{
  config,
  lib,
  pkgs,
  ...
}:
{

  # -- GNOME configuration
  services = {
    desktopManager.gnome.enable = lib.mkDefault true;
    displayManager.gdm.enable = lib.mkDefault true;
  };
  # Remove default GNOME applications
  # Sources:
  # - https://discourse.nixos.org/t/howto-disable-most-gnome-default-applications-and-what-they-are
  # - https://discourse.nixos.org/t/nixos-gnome-remove-xterm-tour-and-manual
  environment.gnome.excludePackages = with pkgs; [
    evince
    geary
    monitor
    # seahorse # TODO: `gpt-agent` pinentry without Seahorse
    totem
    yelp

    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
  ];

  # -- Programs
  programs.firefox.enable = true;

  environment.systemPackages =
    let
      gnomeEnabled = config.services.desktopManager.gnome.enable;
    in
    with pkgs;
    [
      vlc
    ]
    ++ lib.optionals gnomeEnabled [
      papers
      resources

      nautilus-python

      celluloid
      warp
    ];

  # -- Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.sauce-code-pro
    ];
  };
}

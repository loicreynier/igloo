{ self, ... }: {
  flake.nixosModules.gnome =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.graphical
      ];

      services = {
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };

      # Remove default GNOME applications
      # Sources:
      # - https://discourse.nixos.org/t/howto-disable-most-gnome-default-applications-and-what-they-are
      # - https://discourse.nixos.org/t/nixos-gnome-remove-xterm-tour-and-manual
      environment.gnome.excludePackages = with pkgs; [
        evince
        geary
        monitor
        # seahorse # TODO: pinentry without Seahorse
        totem
        yelp

        gnome-contacts
        gnome-maps
        gnome-music
        gnome-tour
        gnome-weather
      ];

      environment.systemPackages = with pkgs; [
        papers
        resources
        celluloid
        warp

        adwaita-qt
      ];
    };
}

{
  flake.nixosModules.gaming =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      environment.systemPackages =
        with pkgs;
        [
          protonplus
        ]
        ++ lib.optionals config.services.desktopManager.gnome.enable [
          adwsteamgtk
        ];
    };
}

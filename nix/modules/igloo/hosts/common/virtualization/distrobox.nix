{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.igloo.system.virtualization;
in {
  config = lib.mkIf cfg.distrobox.enable {
    environment.systemPackages = [
      pkgs.distrobox
    ];

    systemd.user = {
      timers."distrobox-update" = {
        enable = true;
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "1h";
          OnUnitActiveSec = "1d";
          Unit = "distrobox-update.service";
        };
      };

      services."distrobox-update" = {
        enable = true;
        script = ''
          ${pkgs.distrobox}/bin/distrobox upgrade --all
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
  };
}

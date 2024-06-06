{
  lib,
  config,
  pkgs,
  ...
}: {
  systemd = with lib;
    mkIf (any (device: device == config.igloo.device.type) [
      "server"
      "workstation"
      "wsl"
    ]) {
      services.clean-tmp = {
        description = "Clean '/tmp' files older than 10 days";
        script = ''
          ${pkgs.findutils}/bin/find /tmp -type f,s -atime +10 -delete
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
      timers.clean-tmp = {
        wantedBy = ["timers.target"];
        description = "Clean '/tmp' directory";
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          Unit = "clean-tmp.service";
        };
      };
    };
}

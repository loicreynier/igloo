{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.igloo.system.virtualization;

  enableNvidiaContainers =
    (builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers)
    || (config.igloo.device.type == "wsl");
in {
  config = lib.mkIf cfg.podman.enable {
    virtualisation = {
      podman = {
        enable = true;
        autoPrune = {
          enable = true;
          flags = ["--all"];
          dates = "weekly";
        };
      };

      containers.cdi.dynamic.nvidia.enable = enableNvidiaContainers;
    };

    environment.systemPackages = lib.mkIf enableNvidiaContainers [
      pkgs.nvidia-container-toolkit
    ];
  };
}

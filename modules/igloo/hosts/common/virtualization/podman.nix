{
  lib,
  config,
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
    };

    hardware.nvidia-container-toolkit = {
      # References:
      # - https://github.com/NixOS/nixpkgs/pull/312253
      # - https://github.com/nix-community/NixOS-WSL/issues/433
      enable = enableNvidiaContainers;
      # Don't mount NVIDIA drivers/execs from NixOS but from WSL instead
      mount-nvidia-executables = false;
      mount-nvidia-docker-1-directories = false;
    };

    wsl.useWindowsDriver = enableNvidiaContainers;
  };
}

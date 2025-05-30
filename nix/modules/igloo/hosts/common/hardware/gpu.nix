{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.igloo.device.gpu.type == "nvidia") {
    hardware = {
      graphics.enable = true; # Enable OpenGL
      nvidia = {
        open = lib.mkDefault true;
        modesetting.enable = lib.mkDefault true;
        powerManagement = {
          enable = false; # Experimental, and can cause sleep/suspend to fail
          finegrained = false;
        };
        package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
        nvidiaSettings = true;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}

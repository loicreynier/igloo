{
  system.stateVersion = "24.11";
  networking.hostName = "latios-wsl";
  services.openssh.ports = [2201];

  wsl.defaultUser = "loic";

  igloo = {
    device = {
      type = "wsl";
      gpu.type = "intel";
    };
  };
}

{
  system.stateVersion = "23.11";

  networking.hostName = "smaug";

  igloo.device.type = "wsl";

  services.openssh.ports = [2201];

  wsl.defaultUser = "loic";
}

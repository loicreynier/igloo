{
  system.stateVersion = "23.11";

  networking.hostName = "smaug-wsl";

  igloo.device.type = "wsl";

  services.openssh.ports = [2201];

  wsl.defaultUser = "loic";
}

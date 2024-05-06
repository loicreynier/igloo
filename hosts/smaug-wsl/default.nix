{
  system.stateVersion = "23.11";

  networking.hostName = "smaug-wsl";

  igloo = {
    device.type = "wsl";
    system = {
      virtualization = {
        podman.enable = true;
        distrobox.enable = true;
      };
    };
  };

  services.openssh.ports = [2201];

  wsl.defaultUser = "loic";
}

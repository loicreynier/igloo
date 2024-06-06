{
  system.stateVersion = "23.11";
  networking.hostName = "smaug-wsl";
  services.openssh.ports = [2201];

  wsl.defaultUser = "loic";

  igloo = {
    device = {
      type = "wsl";
      gpu.type = "nvidia";
    };

    system = {
      virtualization = {
        podman.enable = true;
        distrobox.enable = true;
      };
    };
  };
}

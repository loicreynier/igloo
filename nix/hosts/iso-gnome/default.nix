{
  lib,
  modulesPath,
  ...
}:
{
  igloo = {
    device = {
      type = "iso";
      gpu.type = "nvidia";
    };
  };

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
  ];

  system.stateVersion = "25.11";

  networking = {
    hostName = "nixos";
  };

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
    xserver.displayManager.gdm.autoSuspend = false;
  };

  systemd = {
    services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  users.extraUsers.root.password = lib.mkForce "nixos"; # S/O to DT

  time.hardwareClockInLocalTime = true;
}

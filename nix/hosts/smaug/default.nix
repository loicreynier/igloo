{
  config,
  lib,
  modulesPath,
  ...
}:
{
  igloo = {
    device = {
      type = "desktop";
      gpu.type = "nvidia";
    };
  };

  imports = [
    # Detect Wi-Fi
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disks.nix
  ];

  system.stateVersion = "25.05"; # Required for RTX 50 series drivers

  hardware = {
    graphics.enable = true; # Enable OpenGL
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = false; # Experimental, and can cause sleep/suspend to fail
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta; # 25.05 -> beta = RTX 50 series drivers
      nvidiaSettings = true;
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  security.rtkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/301d4809-d66d-4ddf-94a3-2df8f301d281";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3884-FCB0";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  networking = {
    hostName = "smaug";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    pulseaudio.enable = false; # For PipeWire setup
  };
}

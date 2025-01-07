{
  config,
  lib,
  modulesPath,
  ...
}: {
  igloo = {
    device = {
      type = "laptop";
      gpu.type = "intel";
    };
  };

  imports = [
    # TODO: why does this fix Wi-Fi?
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  system.stateVersion = "24.11";

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [];

      luks = let
        uuid = "090ad507-d529-4490-af3f-db00c8a16f2a";
      in {
        devices."luks-${uuid}".device = "/dev/disk/by-uuid/${uuid}";
      };
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5e01dfd3-c421-4570-af24-aa35d68e69ac";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9FD6-DC88";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  networking = {
    hostName = "latios";
    networkmanager.enable = true;
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

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  security.rtkit.enable = true;
}

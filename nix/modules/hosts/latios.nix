{ self, inputs, ... }:
{
  flake.nixosConfigurations.latios = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      base
      home-manager
      hostsLatios
      userLoic
      userInvite
      gnome
      gaming
      lab
    ];
  };

  flake.nixosModules.hostsLatios =
    {
      lib,
      config,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

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
          kernelModules = [ ];

          luks =
            let
              uuid = "090ad507-d529-4490-af3f-db00c8a16f2a";
            in
            {
              devices."luks-${uuid}".device = "/dev/disk/by-uuid/${uuid}";
            };
        };
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];

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
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
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
    };
}

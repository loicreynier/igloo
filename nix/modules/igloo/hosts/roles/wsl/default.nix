{pkgs, ...}: {
  # -- WSL configuration
  wsl = {
    enable = true;
    nativeSystemd = true;
    # Doc: https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconf
    wslConf = {
      automount.root = "/mnt"; # Mount Windows drives here
      interop.enabled = true; # Support running Windows binaries from Linux shell
    };
  };

  # -- Environment
  environment = {
    systemPackages = with pkgs; [
      wslu
      wsl-open
      wsl-vpnkit
    ];

    shellAliases = {
      xdg-open = "wsl-open";
    };

    variables = with pkgs; {
      NIX_LD_LIBRARY_PATH = lib.mkForce (lib.makeLibraryPath [
        # Keep the default and NVIDIA driver
        "/run/current-system/sw/share/nix-ld"
        "/usr/lib/wsl" # Windows NVIDIA driver
      ]);
      LD_LIBRARY_PATH = lib.makeLibraryPath [
        "/usr/lib/wsl"
      ];
    };
  };

  # -- Mount root to `/mnt/wsl/instances` so it can be accessed by other WSLs
  # Source: https://superuser.com/questions/1659218
  #
  # An alternative not using `/etc/fstab` could be adding something
  # like the following snippet in `~/.profile`:
  #
  #     if [ ! -d "/mnt/wsl/instances/$WSL_DISTRO_NAME" ]; then
  #         mkdir "/mnt/wsl/instances/$WSL_DISTRO_NAME"
  #         wsl.exe -d "$WSL_DISTRO_NAME" -u root \
  #             mount --bind / "/mnt/wsl/$WSL_DISTRO_NAME/"
  #     fi
  #
  #
  fileSystems."/mnt/wsl/instances/nixos" = {
    device = "/";
    fsType = "none";
    options = [
      "defaults"
      "bind"
      "X-mount.mkdir"
    ];
  };
}

{pkgs, ...}: {
  system.stateVersion = "23.11";

  networking.hostName = "smaug";

  wsl = {
    enable = true;
    defaultUser = "loic";
    nativeSystemd = true;
    # Doc: https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconf
    wslConf = {
      automount.root = "/mnt"; # Mount Windows drives here
      interop.enabled = true; # Support running Windows binaries from Linux shell
    };
  };

  environment.systemPackages = with pkgs; [
    wslu
    wsl-open
    wsl-vpnkit
  ];

  environment.shellAliases = {
    xdg-open = "wsl-open";
  };
}

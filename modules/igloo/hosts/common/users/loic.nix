{pkgs, ...}: {
  users.users.loic = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "nix"
    ];
    # uid = 1001;
    shell = pkgs.bash;
    initialPassword = "loic";
  };
}

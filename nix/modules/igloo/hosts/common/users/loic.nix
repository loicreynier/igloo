{ pkgs, ... }:
{
  users.users.loic = {
    isNormalUser = true;
    description = "Loïc Reynier";
    extraGroups = [
      "wheel"
      "nix"
      "networkmanager"
    ];
    # uid = 1001;
    shell = pkgs.bash;
    initialPassword = "loic";
  };
}

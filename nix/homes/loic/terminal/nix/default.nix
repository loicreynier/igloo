{ pkgs, ... }:
{
  imports = [
    ./comma.nix
  ];

  home.packages = with pkgs; [
    nh
    manix
  ];
}

{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.igloo.system.virtualization = {
    podman = {
      enable = mkEnableOption "Podman";
    };
    distrobox = {
      enable = mkEnableOption "Distrobox";
    };
  };
}

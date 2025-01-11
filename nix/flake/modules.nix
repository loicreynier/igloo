{ self, ... }:
let
  mkFlakeModule =
    path: if builtins.isPath path then self + path else builtins.throw "${path} is not a real path bro";
in
{
  flake = {
    nixosModules = {
      comma-wrapped = mkFlakeModule /modules/nixos/comma;
    };

    homeManagerModules = {
      python = mkFlakeModule /modules/home-manager/programs/python;
    };
  };
}

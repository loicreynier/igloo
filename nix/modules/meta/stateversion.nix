let
  stateVersion = "26.05";
in
{
  flake.homeModules.base = {
    home = { inherit stateVersion; };
  };

  flake.nixosModules.base = {
    system = { inherit stateVersion; };
  };
}

{
  flake.nixosModules.lab =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        paraview
      ];
    };
}

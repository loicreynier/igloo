{
  inputs,
  withSystem,
  ...
}: let
  # -- Wrapper to inherit `inputs` and import shared modules
  mkHome = {
    system,
    username,
    modules,
  } @ args:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({pkgs, ...}: pkgs);
      modules =
        [
          inputs.nixneovim.nixosModules.default
          ../modules/igloo/homes
          ./${username}
        ]
        ++ args.modules or [];
      extraSpecialArgs =
        {
          inherit inputs;
        }
        // args.extraSpecialArgs or {};
    };

  # -- Me, myself, and I
  mkHomeLoic = system: modules:
    mkHome {
      inherit system modules;
      username = "loic";
    };
in {
  # -- Actual home configurations
  flake.homeConfigurations = {
    "loic" = mkHomeLoic "x86_64-linux" [];
  };
}

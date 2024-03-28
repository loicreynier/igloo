{
  inputs,
  withSystem,
  self,
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
          inputs.nixvim.homeManagerModules.nixvim
          inputs.agenix.homeManagerModules.default
          {home.packages = [inputs.agenix.packages."${system}".default];}
          {news.display = "silent";}
          ../modules/igloo/homes
          ../modules/home-manager
          ./${username}
        ]
        ++ args.modules or [];
      extraSpecialArgs =
        {
          inherit inputs self;
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

    "loic@wsl" = mkHomeLoic "x86_64-linux" [
      ./loic/wsl
    ];
  };
}

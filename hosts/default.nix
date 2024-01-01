{
  self,
  inputs,
  lib,
  withSystem,
  ...
}: let
  # -- Flake inputs
  inherit (inputs.home-manager.nixosModules) home-manager;
  inherit (inputs.nixos-wsl.nixosModules) wsl;

  # -- Custom modules
  modulesPath = ../modules;
  iglooModules = modulesPath + /igloo;
  nixosModules = modulesPath + /nixos;
  sharedModules = [
    nixosModules
    home-manager
    (iglooModules + /hosts/options)
  ];

  # -- Wrapper to inherit `inputs` and import shared modules
  mkNixosSystem = {
    name,
    modules,
    system,
    withSystem,
  } @ args:
    withSystem system (
      {
        inputs',
        self',
        ...
      }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            [
              ./${name}
              ./common
            ]
            ++ lib.concatLists [
              args.modules
              sharedModules
            ];
          specialArgs =
            {inherit lib inputs self inputs' self';}
            // args.specialArgs
            or {};
        }
    );
in {
  # -- Actual hosts configurations
  flake.nixosConfigurations = {
    smaug =
      mkNixosSystem
      {
        name = "smaug";
        inherit withSystem;
        system = "x86_64-linux";
        modules = [
          wsl
        ];
      };
  };

  # -- Checks & TODO: run packages
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    sysConfigs =
      lib.filterAttrs
      (_name: value: value.pkgs.system == system)
      self.nixosConfigurations;
  in {
    checks =
      lib.mapAttrs' (name: value: {
        name = "nixos-toplevel-${name}";
        value = value.config.system.build.toplevel;
      })
      sysConfigs;
  };
}

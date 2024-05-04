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
  agenix = inputs.agenix.nixosModules.default;

  # -- Custom modules
  modulesPath = ../modules;
  iglooModules = modulesPath + /igloo;
  nixosModules = modulesPath + /nixos;
  sharedModules = [
    nixosModules
    home-manager
    agenix
    (iglooModules + /hosts/options)
    (iglooModules + /hosts/common)
  ];
  roles = let
    rolesOptions = ["wsl"];
  in
    builtins.listToAttrs (map (name: {
        inherit name;
        value = "${iglooModules}/hosts/roles/${name}";
      })
      rolesOptions);

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
    smaug-wsl =
      mkNixosSystem
      {
        name = "smaug-wsl";
        inherit withSystem;
        system = "x86_64-linux";
        modules = [
          wsl
          roles.wsl
        ];
      };
  };

  # -- Checks & TODO: run packages
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }:
  # Provoke `allow-import-from-derivation-error` during evaluation:
  # https://github.com/purenix-org/purenix/issues/34
  let
    sysConfigs =
      lib.filterAttrs
      (_name: value: value.pkgs.system == system)
      (self.nixosConfigurations or {});
  in {
    checks =
      lib.mapAttrs'
      (
        name: value:
          lib.nameValuePair
          "nixos-toplevel-${name}"
          value.config.system.build.toplevel
      )
      sysConfigs;
  };
}

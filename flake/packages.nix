{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    schemaOverlay = _: _: {
      nix-schema = inputs.nix-schema.packages.${system}.nix.overrideAttrs (old: {
        doCheck = false;
        doInstallCheck = false;
        postInstall =
          old.postInstall
          + ''
            mv $out/bin/nix $out/bin/nix-schema
          '';
      });
    };
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nixpkgs-lor.overlays.default
        inputs.nixneovimplugins.overlays.default
        schemaOverlay # See `./schemas.nix`
      ];
    };
  };
}

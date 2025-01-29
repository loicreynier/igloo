{
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    let
      flakePackages = final: _: {
        x2y = final.callPackage ./x2y { srcPath = "${self}/bin/x2y"; };
        rnm = final.callPackage ./rnm { srcPath = "${self}/bin/rnm"; };
      };

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

      uwufetchFix = _: prev: {
        uwufetch = prev.uwufetch.overrideAttrs (old: {
          postFixup =
            old.postFixup
            + ''
              rm $out/include
            '';
        });
      };
    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nixpkgs-lor.overlays.default
          inputs.awesome-neovim-plugins.overlays.default
          flakePackages
          schemaOverlay # See `./schemas.nix`
          uwufetchFix
        ];
      };

      packages = {
        inherit (pkgs) x2y rnm;
      };
    };
}

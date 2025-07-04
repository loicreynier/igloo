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

      thirdPartyPackages = _: _: {
        nps = inputs.nps.packages.system.default;
      };

      spotifyAdblock = final: _: {
        inherit (final.nur.repos.nltch) spotify-adblock;
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
          inputs.nur.overlays.default
          thirdPartyPackages
          flakePackages
          schemaOverlay # See `./schemas.nix`
          uwufetchFix
          spotifyAdblock
        ];
      };

      packages = {
        inherit (pkgs) x2y rnm;
      };
    };
}

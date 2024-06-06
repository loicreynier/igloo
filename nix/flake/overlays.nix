{
  inputs,
  system,
  ...
}: {
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
}

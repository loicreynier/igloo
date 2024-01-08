{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nixpkgs-lor.overlays.default
        inputs.nixneovimplugins.overlays.default
      ];
    };
  };
}

{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "igloo";
      meta.description = "Devshell for igloos configuration";

      shellHook = ''
        ${config.pre-commit.installationScript}
      '';

      DIRENV_LOG_FORMAT = ""; # Force direnv to shut up

      packages = with pkgs; let
        mkScript = name:
          pkgs.writeShellApplication {
            inherit name;
            text = lib.fileContents ./${name}.sh;
          };
      in [
        age
        alejandra
        ansible
        deadnix
        git
        home-manager
        just
        nil
        magic-wormhole-rs
        statix
        tree

        (mkScript "igloo-update")
        (mkScript "igloo-home-switch")
        (mkScript "igloo-home-build")
        (mkScript "igloo-nixos-switch")
        (mkScript "igloo-nixos-build")
      ];
    };
  };
}

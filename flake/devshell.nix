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

      packages = with pkgs; [
        age
        alejandra
        deadnix
        git
        home-manager
        nil
        magic-wormhole-rs
        statix
        tree

        (
          pkgs.writeShellApplication {
            name = "igloo-update";
            text = ''
              nix flake update \
                && git commit flake.lock -m "build(flake): update inputs"
            '';
          }
        )
      ];
    };
  };
}

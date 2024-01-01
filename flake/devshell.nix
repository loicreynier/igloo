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
        alejandra
        deadnix
        git
        nil
        statix
        tree

        (
          pkgs.writeShellApplication {
            name = "igloo-update";
            text = ''
              nix flake update \
                && git commit flake.lock -m "feat(flake): update inputs"
            '';
          }
        )
      ];
    };
  };
}

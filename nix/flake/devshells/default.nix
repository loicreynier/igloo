{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "igloo";
      meta.description = "Devshell for igloos configuration";

      shellHook = ''
        ${config.pre-commit.installationScript}

        check_flakes_enabled() {
          # Easier to check directly on the command output rather than
          # looking for `/etc/nix/nix.conf` or `~/.config/nix/nix.conf`
          nix flake --help &>/dev/null

          if [ $? -eq 0 ]; then
            return 0
          else
            return 1
          fi
        }

        if ! check_flakes_enabled; then
          echo "Nix flakes are not enabled"
          echo "You can enable them by running the following command:"
          echo "echo 'experimental-features = nix-command flakes' >>~/.config/nix/nix.conf"
        fi
      '';

      DIRENV_LOG_FORMAT = ""; # Force direnv to shut up

      packages = with pkgs; let
        mkScript = name:
          pkgs.writeShellApplication {
            inherit name;
            text = lib.fileContents ./scripts/${name}.sh;
          };
      in [
        age
        alejandra
        deadnix
        git
        home-manager
        just
        nil
        # nix-schema # FIXME
        magic-wormhole-rs
        statix
        tree

        inputs.nix-auto-follow.packages.${system}.default

        (mkScript "igloo-update")
        (mkScript "igloo-home")
        (mkScript "igloo-switch-nixos")
        (mkScript "igloo-build-nixos")
      ];
    };
  };
}

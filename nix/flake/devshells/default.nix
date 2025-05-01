{
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    {
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

        packages =
          with pkgs;
          let
            scriptsDir = "${self}/nix/flake/devshells/scripts";
            # mkScript = name:
            #   pkgs.writeShellApplication {
            #     inherit name;
            #     text = lib.fileContents ${scriptsDir}/${name}.sh;
            #   };
            pythonForIgloo = python3.withPackages (ps: with ps; [ typer ]);
            igloo = pkgs.writeScriptBin "igloo" ''
              ${pythonForIgloo}/bin/python3 ${scriptsDir}/igloo.py "$@"
            '';
          in
          [
            age
            deadnix
            git
            home-manager
            just
            nil
            nixfmt-rfc-style
            # nix-schema # FIXME
            magic-wormhole-rs
            statix
            tree

            igloo
            nix-output-monitor

            (inputs.nix-auto-follow.packages.${system}.default.overridePythonAttrs (_: {
              doCheck = false;
            }))
          ];
      };
    };
}

{
  description = "Typer CLI Python app";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  }: (flake-utils.lib.eachDefaultSystem (
    system: let
      pkgs = import nixpkgs {inherit system;};

      pythonDeps = with pkgs.python3Packages; [
        typer
      ];

      pythonPackage = with pkgs.python3.pkgs;
        buildPythonApplication {
          pname = "app";
          version = "0.1.0";
          src = self;
          format = "pyproject";

          nativeBuildInputs = with pkgs; [
            poetry-core
          ];

          propagatedBuildInputs = pythonDeps;

          pythonImportsCheck = [
            "app"
          ];
        };
    in {
      packages.default = pythonPackage;

      devShells.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with pkgs; [
          poetry
          ruff
          (python3.withPackages (_: pythonDeps))
        ];
      };

      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = "./.";
          excludes = ["flake\.lock"];
          hooks = with pkgs; let
            poetryHookSettings = {
              files = "(poetry\.lock|pyproject\.toml)";
              pass_filenames = false;
            };
          in {
            poetry_check =
              {
                enable = true;
                name = "poetry check";
                entry = "${poetry}/bin/poetry check";
                description = "Check the Poetry config for errors";
              }
              // poetryHookSettings;
            poetry-lock =
              {
                enable = true;
                name = "poetry lock";
                entry = "${poetry}/bin/poetry lock";
                description = "Update the Poetry lock file";
              }
              // poetryHookSettings;

            alejandra.enable = true;
            commitizen.enable = true;
            deadnix.enable = true;
            editorconfig-checker.enable = true;
            markdownlint.enable = true;
            prettier.enable = true;
            ruff.enable = true;
            statix.enable = true;
            typos.enable = true;
          };
        };
      };
    }
  ));

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

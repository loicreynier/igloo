{
  description = "Typer CLI Python app";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    git-hooks,
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
        pre-commit-check = git-hooks.lib.${system}.run {
          src = "./.";
          excludes = ["flake\.lock"];
          hooks = {
            alejandra.enable = true;
            commitizen.enable = true;
            deadnix.enable = true;
            editorconfig-checker.enable = true;
            markdownlint.enable = true;
            poetry-check.enable = true;
            poetry-lock.enable = true;
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
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

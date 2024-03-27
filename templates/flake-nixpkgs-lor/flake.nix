{
  description = "Flake template";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-lor,
    flake-utils,
    pre-commit-hooks,
    ...
  }: (flake-utils.lib.eachDefaultSystem (
    system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nixpkgs-lor.overlays.default
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with pkgs; [
          hello
        ];
      };

      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = "./.";
          excludes = ["flake\.lock"];
          hooks = {
            alejandra.enable = true;
            commitizen.enable = true;
            deadnix.enable = true;
            editorconfig-checker.enable = true;
            markdownlint.enable = true;
            prettier.enable = true;
            statix.enable = true;
            typos.enable = true;
          };
        };
      };
    }
  ));

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-lor = {
      url = "github:loicreynier/nixpkgs-lor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

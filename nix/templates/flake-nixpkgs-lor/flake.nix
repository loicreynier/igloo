{
  description = "Flake template";

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-lor,
      flake-utils,
      git-hooks,
      ...
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nixpkgs-lor.overlays.default
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = with pkgs; [
            hello
          ];
        };

        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = "./.";
            excludes = [ "flake\.lock" ];
            hooks = {
              commitizen.enable = true;
              deadnix.enable = true;
              editorconfig-checker.enable = true;
              markdownlint.enable = true;
              nixfmt-rfc-style.enable = true;
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
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

{
  description = "Igloo";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      git-hooks,
      ...
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };

        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = "./.";
            excludes = [ "flake\.lock" ];
            hooks = {
              editorconfig-checker.enable = true;
              shfmt = {
                enable = true;
                settings = {
                  simplify = false;
                };
              };
              typos.enable = true;
              ruff.enable = true;
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

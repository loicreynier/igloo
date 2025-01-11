{
  description = "Flake template";

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
      ];
      overlays = [
        # ...
      ];
      forAllSystems =
        f:
        nixpkgs.lib.attrsets.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs { inherit overlays system; };
          }
        );
    in
    {
      devShells = forAllSystems (
        { pkgs }:
        with pkgs;
        {
          default = mkShell {
            packages = [
              hello
            ];
          };
        }
      );
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };
}

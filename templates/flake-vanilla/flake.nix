{
  description = "Flake template";

  outputs = {nixpkgs, ...}: let
    supportedSystems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          hello
        ];
      };
    });
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };
}

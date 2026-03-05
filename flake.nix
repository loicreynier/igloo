{
  description = "Igloo";

  outputs =
    { flake-parts, import-tree, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./nix);

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      # url = "github:cachix/git-hooks.nix";
      url = "github:loicreynier/git-hooks.nix/fix/shfmt/ln-editorconfig";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

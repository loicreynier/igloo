{
  description = "Igloo - My Nix/NixOS configurations";

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        # ...
      ];

      imports = [
        ./homes
        ./hosts

        ./flake/packages
        ./flake/pre-commit.nix
        ./flake/devshells
        ./flake/formatter.nix
        ./flake/modules.nix
        ./flake/schemas.nix
        ./flake/templates.nix
      ];
    };

  inputs = {
    # -- NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # -- Nix utilities
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks.url = "github:cachix/git-hooks.nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-schemas.url = "github:gvolpe/flake-schemas";
    nix-schema = {
      inputs.flake-schemas.follows = "flake-schemas";
      url = "github:DeterminateSystems/nix-src/flake-schemas";
    };

    # -- Packages
    nur.url = "github:nix-community/nur";
    nixpkgs-lor = {
      url = "github:loicreynier/nixpkgs-lor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # -- Secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = ""; # Don't download Darwin deps
    };

    # -- Windows Subsystem for Linux (WSL)
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-vscode-remote-wsl = {
      url = "github:sonowz/vscode-remote-wsl-nixos";
      flake = false;
    };

    # -- Neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-parts.follows = "flake-parts";
      };
    };
    nixneovimplugins = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    allow-import-from-derivation = true;
  };
}

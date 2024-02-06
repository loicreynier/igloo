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

        ./flake/packages.nix
        ./flake/pre-commit.nix
        ./flake/devshell.nix
        ./flake/formatter.nix
        ./flake/modules.nix
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
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovimplugins = {
      url = "github:jooooscha/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

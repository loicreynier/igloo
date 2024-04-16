{
  description = "SkyrimSE mod dev environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-lor = {
      url = "github:loicreynier/nixpkgs-lor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fomod-validator = {
      url = "github:loicreynier/fomod-validator-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pandoc-bbcode_nexus = {
      url = "github:loicreynier/pandoc-bbcode_nexus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    nixpkgs-lor,
    pre-commit-hooks,
    fomod-validator,
    pandoc-bbcode_nexus,
    ...
  }: (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        nixpkgs-lor.overlays.default
      ];
    };
    fomodValidator = fomod-validator.packages.${system}.default;
    pandocBBCodeNexus = pandoc-bbcode_nexus.packages.${system}.pandoc-bbcode_nexus;
  in {
    checks = {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;

        excludes = [
          ''^flake\.lock$''
          ''^plugins/.*\.yaml$''
        ];

        hooks = {
          fomod-validator = {
            enable = true;
            name = "fomod_validator";
            entry = "${fomodValidator}/bin/fomod-validator ./data";
            files = "^data/.*\.xml$";
            pass_filenames = false;
          };
          alejandra.enable = true;
          commitizen.enable = true;
          deadnix.enable = true;
          editorconfig-checker.enable = true;
          prettier.enable = true;
          markdownlint.enable = true;
          statix.enable = true;
          typos.enable = true;
        };
      };
    };

    devShells.default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      packages = with pkgs; [
        just
        fomodValidator
        pandocBBCodeNexus
        spriggit
        zip
      ];
    };
  }));
}

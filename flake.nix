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
        gitHooks = self.checks.${system}.pre-commit;
      in
      {
        devShells.default = pkgs.mkShell {
          inherit (gitHooks) shellHook;
          buildInputs = gitHooks.enabledPackages;
        };

        checks =
          let
            mkHook =
              name: args:
              {
                inherit name;
                enable = args.enable or true;
              }
              // builtins.removeAttrs args [ "enable" ];
          in
          {
            pre-commit = git-hooks.lib.${system}.run {
              src = "./.";
              configPath = "./.pre-commit-config-nix.yaml";
              package = pkgs.prek;
              excludes = [ "flake\.lock" ];
              hooks = {
                nixfmt = mkHook "Format >> Nix files (nixfmt)" { };
                shfmt = mkHook "Format >> Shell files (shfmt-system)" {
                  settings = {
                    simplify = false;
                  };
                };
                ruff-format = mkHook "Format >> Python files (ruff-format)" { };
                end-of-file-fixer = mkHook "Format >> End of line fixer (end-of-file-fixer)" { };
                check-symlinks = mkHook "Check  >> Symlinks (check-symlinks)" { };
                check-added-large-files = mkHook "Check  >> Added large files (check-added-large-files)" { };
                check-toml = mkHook "Check  >> TOML files (check-toml)" { };
                check-yaml = mkHook "Check  >> YAML Files (check-YAML)" { };
                typos = mkHook "Check  >> Typos (typos)" { };
                editorconfig-checker = mkHook "Check  >> EditorConfig compliance (editorconfig-checker)" { };
                deadnix = mkHook "Lint   >>> Nix files (deadnix)" { };
                statix = mkHook "Lint   >>> Nix files (statix)" { };
                ruff = mkHook "Lint   >> Python files (ruff-check)" { };
                shellcheck = mkHook "Lint   >> Shell files (shellcheck-system)" { };
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

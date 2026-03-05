{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
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
      pre-commit.settings = {
        configPath = "./.pre-commit-config-nix.yaml";
        package = pkgs.prek;
        excludes = [ "flake\.lock" ];

        hooks = {
          nixfmt = mkHook "Format >> Nix files (nixfmt)" { priority = 0; };
          shfmt = mkHook "Format >> Shell files (shfmt-system)" {
            priority = 0;
            settings = {
              # Default flags override EditorConfig
              language-dialect = null;
              simplify = false;
            };
          };
          ruff-format = mkHook "Format >> Python files (ruff-format)" { priority = 0; };
          taplo = mkHook "Format >> TOML Files (taplo)" { priority = 0; };
          end-of-file-fixer = mkHook "Format >> End of line fixer (end-of-file-fixer)" { priority = 1; };
          check-symlinks = mkHook "Check  >> Symlinks (check-symlinks)" { priority = 10; };
          check-added-large-files = mkHook "Check  >> Added large files (check-added-large-files)" {
            priority = 10;
          };
          check-toml = mkHook "Check  >> TOML files (check-toml)" { priority = 10; };
          check-yaml = mkHook "Check  >> YAML Files (check-YAML)" { priority = 10; };
          typos = mkHook "Check  >> Typos (typos)" { priority = 10; };
          editorconfig-checker = mkHook "Check  >> EditorConfig compliance (editorconfig-checker)" {
            priority = 10;
          };
          deadnix = mkHook "Lint   >> Nix files (deadnix)" { priority = 10; };
          statix = mkHook "Lint   >> Nix files (statix)" { priority = 10; };
          ruff = mkHook "Lint   >> Python files (ruff-check)" { priority = 10; };
          shellcheck = mkHook "Lint   >> Shell files (shellcheck-system)" { priority = 10; };
        };
      };

      devshells.default.devshell = {
        startup = {
          pre-commit.text = config.pre-commit.installationScript;
        };
        packages = config.pre-commit.settings.enabledPackages;
      };
    };
}

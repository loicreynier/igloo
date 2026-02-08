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
          deadnix = mkHook "Lint   >> Nix files (deadnix)" { };
          statix = mkHook "Lint   >> Nix files (statix)" { };
          ruff = mkHook "Lint   >> Python files (ruff-check)" { };
          shellcheck = mkHook "Lint   >> Shell files (shellcheck-system)" { };
          taplo = mkHook "Format >> TOML Files (taplo)" { };
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

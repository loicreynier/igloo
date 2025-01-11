{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    {
      pkgs,
      # system,
      ...
    }:
    let
      # General exclude list
      globalExcludes = [
        "flake.lock"
        ".*age$"
        "ltex.*txt$"
      ];

      # Hook to add the exclusion list
      mkHook =
        name: args:
        {
          excludes = globalExcludes ++ args.excludes or [ ];
          description = "pre-commit hook for ${name}";
          # fail_fast = true;
          # verbose = true;
        }
        // builtins.removeAttrs args [ "excludes" ];
    in
    {
      pre-commit = {
        check.enable = true;

        settings = {
          excludes = globalExcludes;

          hooks = {
            # -- Pre-commit additions
            make_readme = mkHook "make-readme" {
              enable = true;
              entry = "${pkgs.stdenv.shell} .github/make-readme.sh";
              files = "README\.md";
              language = "system";
              pass_filenames = false;
            };
            check_github_urls_branch = mkHook "check-github-urls-branch" {
              enable = true;
              entry = "${pkgs.python3}/bin/python3 .pre-commit/check_github_urls_branch.py";
              language = "system";
            };
            # FIXME: see error while running
            # nix-auto-follow = mkHook "nix-auto-follow" {
            #   enable = true;
            #   entry = "${inputs.nix-auto-follow.packages.${system}.default}/bin/auto-follow --check";
            #   files = "flake\.nix";
            #   language = "system";
            #   pass_filenames = false;
            # };
            commitlint =
              let
                nodeEnv = pkgs.nodePackages."@commitlint/config-conventional";
              in
              mkHook "commitlint" {
                enable = true;
                entry = "env NODE_PATH=${nodeEnv}/lib/node_modules ${pkgs.commitlint}/bin/commitlint -e";
                stages = [ "commit-msg" ];
                language = "system";
                pass_filenames = false;
              };

            # -- Nix
            nixfmt-rfc-style = mkHook "nixfmt" { enable = true; };
            deadnix = mkHook "deadnix" { enable = true; };
            statix = mkHook "statix" { enable = true; };
            flake-checker = mkHook "Flake checker" {
              enable = true;
              always_run = true;
            };

            # -- General linters/formatters
            editorconfig-checker = mkHook "editorconfig" {
              enable = true;
              always_run = true;
            };
            prettier = mkHook "prettier" { enable = true; };
            typos = mkHook "typos" { enable = true; };

            # -- Language specific linters/formatters
            commitizen = mkHook "commitizen" { enable = false; };
            markdownlint = mkHook "markdownlint" { enable = true; };
            shellcheck = mkHook "shellcheck" { enable = true; };
            shfmt = mkHook "shfmt" { enable = true; };
            ruff = mkHook "Ruff" { enable = true; };
            stylua = mkHook "stylua" { enable = true; };
            taplo = mkHook "taplo" { enable = true; };
            yamllint = mkHook "yamllint" { enable = true; };
          };
        };
      };
    };
}

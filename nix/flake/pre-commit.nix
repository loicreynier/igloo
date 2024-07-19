{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem = {pkgs, ...}: let
    # General exclude list
    globalExcludes = [
      "flake.lock"
      ".*age$"
      "ltex.*txt$"
    ];

    # Hook to add the exclusion list
    mkHook = name: args:
      {
        excludes = globalExcludes ++ args.excludes or [];
        description = "pre-commit hook for ${name}";
        # fail_fast = true;
        # verbose = true;
      }
      // builtins.removeAttrs args ["excludes"];
  in {
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

          # -- Nix
          alejandra = mkHook "Alejandra" {enable = true;};
          deadnix = mkHook "deadnix" {enable = true;};
          statix = mkHook "statix" {enable = true;};
          flake-checker = mkHook "Flake checker" {
            enable = true;
            always_run = true;
          };

          # -- General linters/formatters
          editorconfig-checker = mkHook "editorconfig" {
            enable = true;
            always_run = true;
          };
          prettier = mkHook "prettier" {enable = true;};
          typos = mkHook "typos" {enable = true;};

          # -- Language specific linters/formatters
          commitizen = mkHook "commitizen" {enable = true;};
          markdownlint = mkHook "markdownlint" {enable = true;};
          shellcheck = mkHook "shellcheck" {enable = true;};
          shfmt = mkHook "shfmt" {enable = true;};
          ruff = mkHook "Ruff" {enable = true;};
          stylua = mkHook "stylua" {enable = true;};
          taplo = mkHook "taplo" {enable = true;};
          yamllint = mkHook "yamllint" {enable = true;};
        };
      };
    };
  };
}

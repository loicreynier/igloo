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
          make_readme = mkHook "make-readme" {
            enable = true;
            entry = "${pkgs.stdenv.shell} .github/make-readme.sh";
            files = "README\.md";
            language = "system";
            pass_filenames = false;
          };

          alejandra = mkHook "Alejandra" {enable = true;};
          commitizen = mkHook "commitizen" {enable = true;};
          deadnix = mkHook "deadnix" {enable = true;};
          editorconfig-checker = mkHook "editorconfig" {
            enable = true;
            always_run = true;
          };
          markdownlint = mkHook "markdownlint" {enable = true;};
          prettier = mkHook "prettier" {enable = true;};
          shellcheck = mkHook "shellcheck" {enable = true;};
          shfmt = mkHook "shfmt" {enable = true;};
          ruff = mkHook "Ruff" {enable = true;};
          statix = mkHook "statix" {enable = true;};
          stylua = mkHook "stylua" {enable = true;};
          typos = mkHook "typos" {enable = true;};
          taplo = mkHook "taplo" {enable = true;};
          yamllint = mkHook "yamllint" {enable = true;};
        };
      };
    };
  };
}

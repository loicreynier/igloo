{
  config,
  pkgs,
  self,
  ...
}:
{
  home.packages = with pkgs; [
    git-fire
  ];

  programs = {
    git = {
      enable = true;

      signing = {
        key = "contact@loicreynier.fr";
        signByDefault = true;
      };

      ignores = [
        ".cache/"
        ".direnv/"
        "__pycache__/"
        "*.swp"
        "*.bak"
        "*.old"
        "*.~lock"
        "result"
        "debug.log"
      ];

      settings = {
        user = {
          name = "Loïc Reynier";
          email = "contact@loicreynier.fr";
          signingKey = "contact@loicreynier.fr";
        };
        color.ui = "auto";
        core.autocrlf = "input";
        core.pager = "cat";
        diff.algorithm = "histogram"; # When using `--no-ext-diff`
        init.defaultBranch = "main";
        log.data = "iso";
        pull.rebase = true;
        push.default = "current";
        push.autoSetupRemote = true; # Automatically track remote branch
        rere.enabled = true; # Reuse merge conflict fixes when rebasing
        url = {
          "https://github.com/".insteadOf = "github:";
          "ssh://git@github.com/".pushInsteadOf = "github:";
          "https://gitlab.com/".insteadOf = "gitlab:";
          "ssh://git@gitlab.com/".pushInsteadOf = "gitlab:";
          "ssh://git@gitlab.in2p3.fr/".insteadOf = "in2p3:";
          "ssh://git@gitlab.in2p3.fr/".pushInsteadOf = "in2p3:";
          "https://aur.archlinux.org/".insteadOf = "aur:";
          "ssh://aur@aur.archlinux.org/".pushInsteadOf = "aur:";
          "https://git.sr.ht/".insteadOf = "srht:";
          "ssh://git@git.sr.ht/".pushInsteadOf = "srht:";
          "https://codeberg.org/".insteadOf = "codeberg:";
          "ssh://git@codeberg.org/".pushInsteadOf = "codeberg:";
        };

        alias =
          let
            fzfBin = "${config.programs.fzf.package}/bin/fzf";
            difftBin = "${pkgs.difftastic}/bin/difft";
            fzfStage = pkgs.stdenv.mkDerivation {
              name = "fzf-git-stage";
              src = "${self}/config/bash/functions/fzf-git-stage.bash";
              dontUnpack = true;
              doBuild = false;
              installPhase = ''
                mkdir -p $out/share/bash
                sed -e 's,fzf_bin="fzf",fzf_bin=${fzfBin}',g \
                    -e 's,difft_bin="difft",difft_bin=${difftBin},g' \
                    $src > $out/share/bash/fzf-git-stage.bash
              '';
            };
          in
          {
            "ch" = "!git checkout $(git branch --sort='-committerdate' | fzf --reverse --height 40%)";
            "log1" = "log --oneline";
            "log1d" = "log --pretty='format:%Cblue%>(22)%ad %C(yellow)%h %Cred%d %Creset%s' --date=relative";
            "push-all" = "!git remote | xargs -L1 git push --all";
            "sf" = "!bash -c 'source ${fzfStage}/share/bash/fzf-git-stage.bash && __fzf_git_stage'";
            "stash-untracked" = ''
              !f() {
                git stash;
                git stash -u;
                git stash pop stash@{1};
              }; f
            '';
          };
      };
    };

    difftastic.git.enable = true;

    gh = {
      enable = true;

      gitCredentialHelper.enable = false;
      extensions = with pkgs; [
        gh-dash # Dashboard with PR and issues
        gh-eco # Explore the ecosystem
        gh-f # FZF shenanigans
        gh-notify # Show notifications
        gh-markdown-preview # Bro
      ];
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
  };

  home.shellAliases = {
    groot = "cd $(git rev-parse --show-toplevel)";
  };
}

{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Loïc Reynier";
    userEmail = "loic@loicreynier.fr";
    signing = {
      key = "loic@loicreynier.fr";
      signByDefault = true;
    };

    extraConfig = {
      core.autocrlf = "input";
      core.pager = "cat";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "current";
      color.ui = "auto";
      url = {
        "https://github.com/".insteadOf = "github";
        "ssh://git@github.com/".pushInsteadOf = "github:";
        "https://gitlab.com/".insteadOf = "gitlab";
        "ssh://git@gitlab.com/".pushInsteadOf = "gitlab:";
        "https://gitlab.in2p3.fr/".insteadOf = "in2p3:";
        "ssh://git@gitlab.in2p3.fr/".pushInsteadOf = "in2p3:";
        "https://aur.archlinux.org/".insteadOf = "aur:";
        "ssh://aur@aur.archlinux.org/".pushInsteadOf = "aur:";
        "https://git.sr.ht/".insteadOf = "srht:";
        "ssh://git@git.sr.ht/".pushInsteadOf = "srht:";
        "https://codeberg.org/".insteadOf = "codeberg:";
        "ssh://git@codeberg.org/".pushInsteadOf = "codeberg:";
      };
    };

    difftastic.enable = true;

    ignores = [
      ".cache/"
      ".direnv/"
      "*.swp"
      "*.~lock"
      "result"
    ];

    aliases = {
      "log1" = "log --oneline";
      "push-all" = "!git remote | xargs -L1 git push --all";
      "stash-untracked" = ''
        !f() {
          git stash;
          git stash -u;
          git stash pop stash@{1};
        }; f
      '';
    };
  };

  programs.gh = {
    enable = true;

    gitCredentialHelper.enable = false;
    extensions = with pkgs; [
      gh-dash # Dashboard with PR and issues
      gh-eco # Explore the ecosystem
      gh-cal # Contributions calendar viewer
    ];
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}

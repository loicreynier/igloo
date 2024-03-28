{
  pkgs,
  self,
  ...
}: {
  programs.bat = {
    enable = true;
    syntaxes = {
      just = {
        src = pkgs.fetchFromGitHub {
          owner = "nk9";
          repo = "just_sublime";
          rev = "08bbc62e9e77c82fb0fa6cabc0630cb5cc4bcd0e";
          hash = "sha256-wSZe0uklnH3SooFR8RqAeGj3WL3W2cqNeSH/nQS3/4s=";
        };
        file = "Syntax/Just.sublime-syntax";
      };
      gleam = {
        src = pkgs.fetchFromGitHub {
          owner = "molnarmark";
          repo = "sublime-gleam";
          rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
          hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
        };
        file = "syntax/gleam.sublime-syntax";
      };
      numbat = {
        src = pkgs.fetchFromGitHub {
          owner = "sharkdp";
          repo = "numbat";
          rev = "6572a27ee02952b58740a960e73b30da410e392e";
          hash = "sha256-uvh2blo86J9nCsl0y8huaom39Kg2x3XZ7YBEi1kU62E=";
        };
        file = "assets/numbat.sublime-syntax";
      };
      typst = {
        src = pkgs.fetchFromGitHub {
          owner = "hyrious";
          repo = "typst-syntax-highlight";
          rev = "4f7f30d7ee52987f2e219ad42c47cf7aca3a62ef";
          hash = "sha256-WuW4HfKmgEl/drEt1urhDjCdTuKGbtWiVDdZt84lcOY=";
        };
        file = "Typst.sublime-syntax";
      };
    };
  };

  xdg.configFile."bat/config".source = "${self}/config/bat/plain-vscode.conf";
}

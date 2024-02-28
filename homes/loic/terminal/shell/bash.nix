{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.bash;
in {
  programs.bash = {
    enable = true;

    historySize = 1000;
    historyFileSize = 1000;
    historyFile = "${config.xdg.stateHome}/bash_history";
    historyControl = [
      "ignoredups"
      "ignorespace"
      "erasedups"
    ];
    historyIgnore = [
      "?"
      "??"

      "pwd"
      "clear"
      "tree"
      "history"
      "exit"

      "pass*"
    ];

    shellOptions = [
      "histappend"
      "autocd"
      "direxpand"
      "dirspell"
      "extglob"
      "globstar"
      "checkjobs"
      "checkwinsize"
    ];
  };

  home.file.".bash_completion".text = lib.mkIf cfg.enable (lib.mkOrder 0 ''
    source ${pkgs.complete-alias}/bin/complete_alias
  '');
}

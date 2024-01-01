{config, ...}: {
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
}

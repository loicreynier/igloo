{
  lib,
  config,
  self,
  ...
}:
{
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
      "autocd" # Treat command as `cd` argument if command is a directory name
      "cdspell" # Fix spelling while `cd`-ing
      "checkjobs" # Prevent exiting if jobs are running
      "direxpand" # Expand `~` paths and more during completion
      "dirspell" # Fix dir names during completion
      "dotglob" # Globbing also includes dotfiles
      "extglob" # Enable advanced pattern matching
      "globstar" # Enable `**` for subdirectory globbing
      "histappend" # Append to history file instead of overwriting it
    ];

    initExtra = lib.strings.fileContents "${self}/config/bash/functions/core-utils.bash";
  };
}

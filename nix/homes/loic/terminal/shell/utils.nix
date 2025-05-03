{
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  programs = {
    zoxide.enable = true;
  };

  programs.bash.initExtra = lib.strings.fileContents "${self}/config/bash/functions/zoxide-pushd.bash";

  home = {
    packages = with pkgs; [
      edir
      eza # Don't use HM module which only sets aliases
    ];

    sessionVariables = {
      "_ZO_DATA_DIR" = "${config.xdg.stateHome}";
    };

    shellAliases =
      let
        eza = "${pkgs.eza}/bin/eza --group-directories-first --color=auto --icons=auto --git";
      in
      {
        "ls" = "${eza}";
        "l" = "ls -lba";
        "l1" = "ls -1";
        "ll" = "ls -lb";
        "la" = "ls -a";
        "lla" = "ls -lba";
        "l." = "ls -d .*";
        "ll." = "ls -lbd .*";
        "lrt" = "ls -snew";
        "llrt" = "ls -lbsnew";
        "lt" = "ls --tree";
        "tree" = "ls --tree";
      };
  };
}

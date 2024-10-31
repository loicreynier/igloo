{
  config,
  pkgs,
  ...
}: {
  programs = {
    zoxide.enable = true;
  };

  home = {
    packages = with pkgs; [
      edir
      eza # Don't use HM module which only sets aliases
    ];

    sessionVariables = {
      "_ZO_DATA_DIR" = "${config.xdg.stateHome}";
    };

    shellAliases = let
      eza = "${pkgs.eza}/bin/eza --group-directories-first --color=auto --icons=auto --git";
    in {
      "cat" = "bat";
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

{
  config,
  pkgs,
  ...
}: {
  programs = {
    zoxide.enable = true;

    eza = {
      enable = true;
      icons = true;
      git = true;
      extraOptions = [
        "--group-directories-first"
      ];
    };
  };

  home = {
    packages = with pkgs; [
      edir
    ];

    sessionVariables = {
      "_ZO_DATA_DIR" = "${config.xdg.stateHome}";
    };

    shellAliases = {
      "cat" = "bat";
      "ls" = "eza";
      "tree" = "eza --tree";
    };
  };
}

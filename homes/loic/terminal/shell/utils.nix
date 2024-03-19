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

    bat = {
      enable = true;
      config = {
        style = "plain";
        pager = "never";
      };
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

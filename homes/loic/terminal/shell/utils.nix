{config, ...}: {
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

  home.sessionVariables = {
    "_ZO_DATA_DIR" = "${config.xdg.stateHome}";
  };

  home.shellAliases = {
    "cat" = "bat";
    "ls" = "eza";
    "tree" = "eza --tree";
  };
}

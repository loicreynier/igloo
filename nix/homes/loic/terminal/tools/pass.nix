{config, ...}: let
  passDir = "${config.xdg.dataHome}/password-store";
in {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = passDir;
    };
  };

  services.git-sync = {
    repositories = {
      pass = {
        path = passDir;
        uri = "git@github.com:loicreynier/password-store";
      };
    };
  };
}

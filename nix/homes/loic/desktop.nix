{ pkgs, ... }:
{
  programs = {
    firefox = {
      enable = true;
    };

    password-store = {
      package = pkgs.pass.override {
        x11Support = true;
        waylandSupport = true;
      };
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };

  home.packages = with pkgs; [
    discord
    spotify
    thunderbird # Don't configure profiles with HM, yet

    nur.repos.wingej0.nordvpn
  ];
}

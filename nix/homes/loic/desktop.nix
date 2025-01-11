{ pkgs, ... }:
{
  programs = {
    firefox = {
      enable = true;
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
  ];
}

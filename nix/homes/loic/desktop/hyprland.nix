{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    activate-linux
  ];
}

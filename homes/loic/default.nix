{
  config,
  lib,
  ...
}: let
  username = "loic";
in {
  imports = [
    ./terminal
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";
    extraOutputsToInstall = [
      "man"
      "doc"
      "devdoc"
    ];
  };

  services.git-sync.enable = true;
}

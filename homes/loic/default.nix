{
  config,
  lib,
  self,
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

  home.file = {
    ".igloo".source = config.lib.file.mkOutOfStoreSymlink self;
    ".editorconfig".source = "${self}/config/editorconfig/dot-editorconfig";
  };

  services.git-sync.enable = true;
}

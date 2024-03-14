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

    file = {
      ".editorconfig".text =
        lib.strings.fileContents
        ../../config/editorconfig/dot-editorconfig;
    };
  };

  services.git-sync.enable = true;
}

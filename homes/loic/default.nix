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

    file = {
      ".editorconfig".text =
        lib.strings.fileContents
        "${self}/config/editorconfig/dot-editorconfig";
    };
  };

  services.git-sync.enable = true;
}

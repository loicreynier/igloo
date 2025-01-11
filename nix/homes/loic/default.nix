{
  config,
  lib,
  self,
  ...
}:
let
  username = "loic";
in
{
  imports = [
    ./terminal
  ];

  home = rec {
    inherit username;
    homeDirectory = "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.11";
    extraOutputsToInstall = [
      "man"
      "doc"
      "devdoc"
    ];

    sessionPath = [
      "${homeDirectory}/.local/bin"
    ];

    file = {
      ".igloo".source = config.lib.file.mkOutOfStoreSymlink self;
      ".editorconfig".source = "${self}/config/editorconfig/dot-editorconfig";
    };
  };

  services.git-sync.enable = true;
}

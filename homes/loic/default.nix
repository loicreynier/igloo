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
      ".editorconfig".source = "${config.home.homeDirectory}/Code/Projects/Nix/igloo";
      # `self` refers to the Nix store entry, so it's not writable. Do I need it writable?
      # "${self}/config/editorconfig/dot-editorconfig";
    };
  };

  home.file.".igloo".source = config.lib.file.mkOutOfStoreSymlink self;

  services.git-sync.enable = true;
}

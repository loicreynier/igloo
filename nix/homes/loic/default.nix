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

  nix.nixPath = [
    # Fixes "warning: Nix search path entry ..."
    "$HOME/.nix-defexpr/channels"
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.11";
    extraOutputsToInstall = [
      "man"
      "doc"
      "devdoc"
    ];

    file = {
      ".igloo".source = config.lib.file.mkOutOfStoreSymlink self;
      ".editorconfig".source = "${self}/config/editorconfig/dot-editorconfig";
    };
  };

  services.git-sync.enable = true;
}

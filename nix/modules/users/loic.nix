{ self, ... }: {
  flake.homeModules.userLoic = { system, ... }: {
    home.packages = [
      self.packages.${system}.neovimWrapped
    ];
  };

  flake.nixosModules.userLoic = {
    users.users.loic = {
      enable = true;
      initialPassword = "loic";
      description = "Loïc Reynier";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "nix"
        "networkmanager"
        "nordvpn"
      ];
    };

    # home-manager.users.loic = {
    #   imports = [
    #     self.homeModules.userLoic
    #   ];
    #   # FIXME: better integration with `modules/meta/stateversion.nix`?
    #   home = { inherit (config.system) stateVersion; };
    # };

  };
}

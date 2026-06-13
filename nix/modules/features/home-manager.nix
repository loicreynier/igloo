{ inputs, ... }: {
  flake.homeModules.base = {
    programs.home-manager.enable = true;
    news.display = "silent";
    manual = {
      manpages.enable = true;
      json.enable = true;
      html.enable = false;
    };
  };

  flake.nixosModules.home-manager = { ... }: {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}

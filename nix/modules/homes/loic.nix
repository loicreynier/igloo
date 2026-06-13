{ self, inputs, ... }:
let
  userName = "loic";
  system = "x86_64-linux";
in
{
  flake.homeConfigurations."${userName}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { inherit system; };
    extraSpecialArgs = { inherit system; };
    modules = with self.homeModules; [
      base
      userLoic
      {
        home.username = "${userName}";
        home.homeDirectory = "/home/${userName}";
      }
    ];
  };
}

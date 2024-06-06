{self, ...}: {
  flake.templates = let
    templatePath = name: "${self}/nix/templates/${name}";
  in rec {
    default = flakeDefault;

    flakeDefault = {
      description = "Default flake with `flake-utils` and pre-commit hooks";
      path = templatePath "flake-default";
    };

    flakeNixpkgsLor = {
      description = "Default flake with `flake-utils`, pre-commit hooks and personal `nixpkgs` overlay";
      path = templatePath "flake-nixpkgs-lor";
    };

    flakeVanila = {
      description = "Vanilla-flavored flake";
      path = templatePath "flake-vanilla";
    };

    pythonTyper = {
      description = "Typer Python CLI app packaged with Poetry";
      path = templatePath "python-typer";
    };

    skyrimMod = {
      description = "SkyrimSE mod versioned by Git with Spriggit";
      path = templatePath "skyrim-mod";
    };
  };
}

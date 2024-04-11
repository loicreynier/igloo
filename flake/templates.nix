{self, ...}: {
  flake.templates = {
    flakeDefault = {
      description = "Default flake with `flake-utils` and pre-commit hooks";
      path = "${self}/templates/flake-default";
    };

    flakeNixpkgsLor = {
      description = "Default flake with `flake-utils`, pre-commit hooks and personal `nixpkgs` overlay";
      path = "${self}/templates/flake-nixpkgs-lor";
    };

    flakeVanila = {
      description = "Vanilla-flavored flake";
      path = "${self}/templates/flake-vanilla";
    };

    pythonTyper = {
      description = "Typer Python CLI app packaged with Poetry";
      path = "${self}/templates/python-typer";
    };

    skyrimMod = {
      description = "SkyrimSE mod versioned by Git with Spriggit";
      path = "${self}/templates/skyrim-mod";
    };
  };
}

{
  flake.templates = {
    flakeDefault = {
      description = "Default flake with `flake-utils` and pre-commit hooks";
      path = ../templates/flake-default;
    };

    flakeNixpkgsLor = {
      description = "Default flake with `flake-utils`, pre-commit hooks and personal `nixpkgs` overlay";
      path = ../templates/flake-nixpkgs-lor;
    };

    flakeVanila = {
      description = "Vanilla-flavored flake";
      path = ../templates/flake-vanilla;
    };

    pythonTyper = {
      description = "Typer Python CLI app packaged with Poetry";
      path = ../templates/python-typer;
    };
  };
}

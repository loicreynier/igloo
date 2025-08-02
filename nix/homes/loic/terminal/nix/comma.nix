{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  programs = {
    nix-index-database.comma.enable = true;
    nix-index.symlinkToCacheHome = true;
    command-not-found.enable = lib.mkForce false;
  };
}

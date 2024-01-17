{
  config,
  lib,
  pkgs,
  ...
}: let
  pylab =
    pkgs.writeShellScriptBin "pylab"
    (builtins.readFile ../../../../bin/pylab);
  # FIXME: doesn't work since the wrapper uses system's Python (and packages)
  pyversion =
    pkgs.writers.writePython3Bin "pyversion" {}
    (builtins.readFile ../../../../bin/pyversion);
in {
  programs.python = {
    enable = true;
    packages = pkgs:
      with pkgs; [
        matplotlib
        numpy
        pandas
      ];
    config =
      lib.strings.fileContents
      (pkgs.substituteAll {
        # TODO: propagate flake root path in variable to simplify
        src = ../../../../config/python/startup.py;
        state = "${config.xdg.stateHome}";
      });
  };

  home.packages = [
    pylab
    pyversion
  ];
}

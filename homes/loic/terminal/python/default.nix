{
  config,
  lib,
  pkgs,
  ...
}: let
  # -- Shell scripts
  pylab =
    pkgs.writeShellScriptBin "pylab"
    (builtins.replaceStrings ["#!/usr/bin/env bash\n"] [""]
      (lib.fileContents ../../../../bin/pylab));
  ipylab =
    pkgs.writeShellScriptBin "ipylab"
    (builtins.replaceStrings ["#!/usr/bin/env bash\n"] [""]
      (lib.fileContents ../../../../bin/ipylab));

  # -- Python scripts wrapper
  writePythonBin = let
    python = config.programs.python.package;
  in
    name:
      pkgs.writers.makePythonWriter
      python
      pkgs.python3Packages
      pkgs.buildPackages.python3Packages
      "/bin/${name}";

  # -- Python scripts
  pyversion =
    writePythonBin "pyversion" {}
    (builtins.replaceStrings ["#!/usr/bin/env python\n"] [""]
      (lib.fileContents ../../../../bin/pyversion));
in {
  programs.python = {
    enable = true;
    packages = pkgs:
      with pkgs; [
        matplotlib
        numpy
        pandas
        ipython
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
    ipylab
    pylab
    pyversion
  ];

  home.file.".ipython/profile_default/ipython_config.py".text =
    lib.fileContents ../../../../config/ipython/ipython_config_default.py;
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  pylab =
    pkgs.writeShellScriptBin "pylab"
    (builtins.replaceStrings ["#!/usr/bin/env bash\n"] [""]
      (lib.fileContents ../../../../bin/pylab));
  ipylab =
    pkgs.writeShellScriptBin "ipylab"
    (builtins.replaceStrings ["#!/usr/bin/env bash\n"] [""]
      (lib.fileContents ../../../../bin/ipylab));
  # FIXME: doesn't work since the wrapper uses system's Python (and packages)
  pyversion =
    pkgs.writers.writePython3Bin "pyversion" {}
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

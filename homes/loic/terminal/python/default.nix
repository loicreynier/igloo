{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  # -- Shell scripts
  pylab =
    pkgs.writeShellScriptBin "pylab"
    (builtins.replaceStrings ["#!/usr/bin/env bash\n"] [""]
      (lib.fileContents "${self}/bin/pylab"));
  ipylab =
    pkgs.writeShellScriptBin "ipylab"
    (builtins.replaceStrings ["#!/usr/bin/env bash\n"] [""]
      (lib.fileContents "${self}/bin/ipylab"));

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
      (lib.fileContents "${self}/bin/pyversion"));
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
        src = "${self}/config/python/startup.py";
        state = "${config.xdg.stateHome}";
      });
  };

  home.packages = [
    ipylab
    pylab
    pyversion
  ];

  home.file.".ipython/profile_default/ipython_config.py".text =
    lib.fileContents "${self}/config/ipython/ipython_config_default.py";
}

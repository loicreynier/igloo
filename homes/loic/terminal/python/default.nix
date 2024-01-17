{
  config,
  lib,
  pkgs,
  ...
}: {
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
}

{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  # -- Shell scripts
  pylab = pkgs.writeShellScriptBin "pylab" (
    builtins.replaceStrings [ "#!/usr/bin/env bash\n" ] [ "" ] (
      lib.fileContents "${self}/scripts/pylab.sh"
    )
  );
  ipylab = pkgs.writeShellScriptBin "ipylab" (
    builtins.replaceStrings [ "#!/usr/bin/env bash\n" ] [ "" ] (
      lib.fileContents "${self}/scripts/ipylab.sh"
    )
  );

  # -- Python scripts wrapper
  writePythonBin =
    let
      python = config.programs.python.package;
    in
    name:
    pkgs.writers.makePythonWriter python pkgs.python3Packages pkgs.buildPackages.python3Packages
      "/bin/${name}";

  # -- Python scripts
  pyversion = writePythonBin "pyversion" { } (
    builtins.replaceStrings [ "#!/usr/bin/env python\n" ] [ "" ] (
      lib.fileContents "${self}/scripts/pyversion.py"
    )
  );
in
{
  programs.python = {
    enable = true;
    packages =
      pkgs: with pkgs; [
        matplotlib
        numpy
        pandas

        pillow
        requests

        ipython
        rich
        pyfzf
      ];
    config = lib.strings.fileContents (
      pkgs.replaceVars "${self}/config/python/startup.py" { state = "${config.xdg.stateHome}"; }
    );
  };

  programs.fzf.enable = lib.mkDefault true; # Enable `fzf` for `pyfzf`

  home.packages = [
    ipylab
    pylab
    pyversion
  ];

  # IPython files
  # TODO: attribute set for IPython profile with startup files as list
  home.file = {
    ".ipython/profile_default/ipython_config.py".source =
      "${self}/config/ipython/ipython_config_default.py";
    ".ipython/profile_default/startup/fzf-hist-search.py".text =
      builtins.replaceStrings
        [
          "bat_bin=\"bat\""
          "sed_bin=\"sed\""
        ]
        [
          "bat_bin=\"${pkgs.bat}/bin/bat\""
          "sed_bin=\"${pkgs.gnused}/bin/sed\""
        ]
        (lib.fileContents "${self}/config/ipython/startup/fzf-hist-search.py");
  };
}

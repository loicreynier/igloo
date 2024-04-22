/*

Setup `pass` and VS Code for WSL


- Import VS Code server module (see `../vscode-server.nix`).

- Install Browserpass binary and installs GUI GPG pinentry.

  Only Browserpass binary is required.
  Home-Manager (and NixOS)'s Browserpass module is only required
  for the configuration of the browser.

- Install a `pass` extension `wclip` to copy passwords into Windows clipboard

- Import Neovim module which sets WSL clipboard integration using `win32yank`
*/
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../vscode-server.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    browserpass
  ];

  home.activation = {
    checkWindowBinaries = let
      # Check whether Windows clipboard binaries are in the expected path.
      # Since activation is not run in the user shell,
      # it is actually not possible to check if they are in `$PATH`.
      # Therefore it only checks if they are in the expected path and prints a warning.
      commands = {
        "clip.exe" = "/mnt/c/Windows/System32/clip.exe";
        "win32yank.exe" = "/mnt/c/Users/Loic/AppData/Local/Microsoft/WinGet/Links/win32yank.exe";
      };
      check = name: path: ''
        if  run --quiet command -v ${path}; then
          echo "Windows binary '${name}' found in '${path}', check if it's in 'PATH'."
        else
          errorEcho '${name}' not found in '${path}'
          exit 1
        fi
      '';
    in
      with builtins;
        lib.hm.dag.entryAfter ["reloadSystemd"]
        (concatStringsSep "\n" (attrValues (mapAttrs check commands)));
  };

  services.gpg-agent = {
    # TODO: replace with `pinentry-wsl`
    # Currently `pinentry-wsl-ps1` does not support WSL 2 with systemd.
    # pinentryFlavor = null;
    # extraConfig = ''
    #   pinentry-program "${pkgs.pinentry-wsl-ps1}/bin/pinentry-wsl-ps1"
    # '';
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  programs.password-store.package = pkgs.pass.withExtensions (_: [
    (pkgs.callPackage ./pass-extension-wclip {})
  ]);
}

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
{pkgs, ...}: {
  imports = [
    ../../vscode-server.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    win32yank-bin
    browserpass
  ];

  services.gpg-agent = {
    # TODO: replace with `pinentry-wsl`
    # Currently `pinentry-wsl-ps1` does not support WSL 2 with systemd.
    # pinentryFlavor = null;
    # extraConfig = ''
    #   pinentry-program "${pkgs.pinentry-wsl-ps1}/bin/pinentry-wsl-ps1"
    # '';
    pinentryFlavor = "gtk2";
  };

  programs.password-store.package = pkgs.pass.withExtensions (_: [
    (pkgs.callPackage ./pass-extension-wclip {})
  ]);
}

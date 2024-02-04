/*

Install Browserpass and VS Code server for WSL


- Import VS Code server module (see `../vscode-server.nix`).

- Install Browserpass binary and installs GUI GPG pinentry.

  Only Browserpass binary is required.
  Home-Manager (and NixOS)'s Browserpass module is only required
  for the configuration of the browser.
*/
{pkgs, ...}: {
  imports = [
    ../vscode-server.nix
  ];

  home.packages = with pkgs; [
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
}

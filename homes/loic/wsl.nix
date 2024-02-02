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

  # TODO: replace with `pinetry-wsl`
  services.gpg-agent.pinentryFlavor = "gtk2";
}

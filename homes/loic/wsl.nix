/*
Install Browserpass binary and installs GUI GPG pinentry

Only Browserpass binary is required.
Home-Manager (and NixOS)'s Browserpass module is only required for
the configuration of the browser.
*/
{pkgs, ...}: {
  home.packages = with pkgs; [
    browserpass
  ];

  # TODO: replace with `pinetry-wsl`
  services.gpg-agent.pinentryFlavor = "gtk2";
}

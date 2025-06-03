{
  imports = [
    ./env
    ./hardware
    ./nix
    ./system
    ./users
    ./networking
    ./virtualization
  ];

  programs.gnupg.agent.enable = true;

  services.openssh.enable = true;
}

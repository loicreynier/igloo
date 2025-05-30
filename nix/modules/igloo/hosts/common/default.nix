{
  imports = [
    ./env
    ./hardware
    ./nix
    ./system
    ./users
    ./virtualization
  ];

  programs.gnupg.agent.enable = true;

  services.openssh.enable = true;
}

{
  imports = [
    ./env
    ./nix
    ./users
    ./virtualization
  ];

  programs.gnupg.agent.enable = true;

  services.openssh.enable = true;
}

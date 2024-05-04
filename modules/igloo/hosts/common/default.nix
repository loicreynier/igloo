{
  imports = [
    ./env
    ./nix
    ./users
  ];

  programs.gnupg.agent.enable = true;

  services.openssh.enable = true;
}

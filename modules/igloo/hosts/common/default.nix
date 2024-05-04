{
  imports = [
    ./env
    ./nix
    ./users
    ./virt
  ];

  programs.gnupg.agent.enable = true;

  services.openssh.enable = true;
}

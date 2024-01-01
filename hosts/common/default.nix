{
  imports = [
    ./env
    ./nix
    ./users
  ];

  programs.gnupg.agent.enable = true;
}

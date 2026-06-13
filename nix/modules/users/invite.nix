{
  flake.nixosModules.userInvite = _: {
    users.users.invite = {
      enable = true;
      description = "Invité (guest)";
      initialPassword = "invite";
      isNormalUser = true;
    };
  };
}

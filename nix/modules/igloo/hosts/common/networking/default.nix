{
  # NOTE: User must be added to the `nordvpn` group (`users.users.extraGroups`)
  # and port UDP 1194 and TCP 443 must be allowed through the firewall
  chaotic.nordvpn.enable = true;
  networking.firewall.checkReversePath = false;
}

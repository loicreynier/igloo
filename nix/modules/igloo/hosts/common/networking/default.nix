{
  lib,
  config,
  ...
}:
let
  useVPN = lib.any (device: device == config.igloo.device.type) [
    "desktop"
    "laptop"
    "workstation"
  ];
in
{
  # NOTE: User must be added to the `nordvpn` group (`users.users.extraGroups`)
  # and port UDP 1194 and TCP 443 must be allowed through the firewall
  chaotic.nordvpn.enable = useVPN;
  networking.firewall.checkReversePath = !useVPN;
}

let
  # -- Users
  loic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAcO4BDzMJBA3vUIS+kHRiCA78KAHmTIPvEUnAfXAfY loic@loicreynier.fr";
  # -- Helper
  mkSecret = list: list ++ [loic];
in {
  # -- Passwords & keys
  "key-ssh-bdp@p2chpd.age".publicKeys = mkSecret [];

  # -- Private config files
  "config-ssh-loic.age".publicKeys = mkSecret [];
}

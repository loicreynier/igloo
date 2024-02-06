{config, ...}: {
  age.secrets = let
    # TODO: propagate flake root path in variable to simplify
    secretsPath = ../../../../secrets;
    sshHomePath = "${config.home.homeDirectory}/.ssh";
  in {
    config-ssh-loic = {
      file = "${secretsPath}/config-ssh-loic.age";
      path = "${sshHomePath}/.ssh/config";
    };
    "key-ssh-bdp@p2chpd" = {
      file = "${secretsPath}/key-ssh-bdp@p2chpd.age";
      path = "${sshHomePath}/id_rsa_bdp@p2chpd";
    };
  };
}

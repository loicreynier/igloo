{
  config,
  self,
  ...
}:
{
  # Enable SSH agent, requires  the following in SSH config:
  #
  #   Host *
  #     AddKeysToAgent yes
  #
  services.ssh-agent.enable = true;

  age.secrets =
    let
      secretsPath = "${self}/secrets";
      sshHomePath = "${config.home.homeDirectory}/.ssh";
    in
    {
      config-ssh-loic = {
        file = "${secretsPath}/config-ssh-loic.age";
        path = "${sshHomePath}/config";
      };
      "key-ssh-bdp@p2chpd" = {
        file = "${secretsPath}/key-ssh-bdp@p2chpd.age";
        path = "${sshHomePath}/id_rsa_bdp@p2chpd";
      };
    };
}

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
      "key-ssh-onera-ed25519" = {
        file = "${secretsPath}/key-ssh-onera-ed25519.age";
        path = "${sshHomePath}/id_ed25519-onera";
      };
      "key-ssh-onera-rsa" = {
        file = "${secretsPath}/key-ssh-onera-rsa.age";
        path = "${sshHomePath}/id_rsa-onera";
      };
    };
}

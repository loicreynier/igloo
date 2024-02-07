{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fzf
    pet
  ];

  # Using encrypted configuration file since it contains GitHub Gist token
  age.secrets."config-pet-loic" = {
    file = ../../../../secrets/config-pet-loic.toml.age;
    path = "${config.xdg.configHome}/pet/config.toml";
  };
}

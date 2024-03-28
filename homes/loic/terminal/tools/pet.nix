{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  home.packages = with pkgs; [
    fzf
    pet
  ];

  # Using encrypted configuration file since it contains GitHub Gist token
  age.secrets."config-pet-loic" = {
    file = "${self}/secrets/config-pet-loic.toml.age";
    path = "${config.xdg.configHome}/pet/config.toml";
  };

  programs.bash.initExtra =
    lib.strings.fileContents
    "${self}/config/bash/functions/pet-select.bash";
}

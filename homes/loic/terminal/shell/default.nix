{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./bash.nix
    ./fzf.nix
    ./utils.nix
    ./vars.nix
  ];

  # -- Readline configuration file
  home.file.".inputrc".source = "${self}/config/readline/dot-inputrc";

  # -- Starship
  programs.starship.enable = true;
  xdg.configFile."starship.toml".source = "${self}/config/starship/default.toml";

  # -- direnv
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      # In case alternative `nix` package is used, such as `nix-super`
      package =
        lib.mkIf (config.nix.package != null)
        (pkgs.nix-direnv.override {
          nix = config.nix.package;
        });
    };
    stdlib =
      lib.strings.fileContents
      (pkgs.substituteAll {
        src = "${self}/config/direnv/direnvrc.sh";
        sha1sum = "${pkgs.perl}/bin/shasum";
      });
  };
}

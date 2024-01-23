{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./bash.nix
    ./starship.nix
    ./utils.nix
  ];

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
        src = ../../../../config/direnv/direnvrc.sh;
        sha1sum = "${pkgs.perl}/bin/shasum";
      });
  };
}

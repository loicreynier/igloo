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

  home.packages = with pkgs; [
    xxh
  ];

  programs = {
    starship.enable = true;

    bat = {
      enable = true;
      installExtraSyntaxes = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batman
        batpipe
        batwatch
        batdiff
        prettybat
      ];
    };
  };

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

  home.file = {
    ".inputrc".source = "${self}/config/readline/dot-inputrc";
  };

  xdg.configFile = {
    "bat/config".source = "${self}/config/bat/plain-vscode.conf";
    "starship.toml".source = "${self}/config/starship/default.toml";
    "xxh/config.xxhc".source = "${self}/config/xxh/config.xxhc";
  };
}

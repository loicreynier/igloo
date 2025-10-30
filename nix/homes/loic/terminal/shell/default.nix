{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./powershell.nix
  ];

  home = {
    file = {
      ".bashrc".source = "${self}/config/bash/.bashrc";
      ".profile".source = "${self}/config/sh/.profile";
    };

    packages = with pkgs; [
      bash-completion
      bash-preexec
      fzf
      fzf-tab-completion
      zoxide
      eza
      edir
      starship

      atuin
      pet
      xxh
    ];
  };

  programs = {
    bat = {
      enable = true;
      installExtraSyntaxes = true;
      extraPackages = with pkgs.bat-extras; [
        # batgrep # FIXME: tests are failing
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
      package = lib.mkIf (config.nix.package != null) (
        pkgs.nix-direnv.override {
          nix = config.nix.package;
        }
      );
    };
    stdlib = lib.strings.fileContents (
      pkgs.replaceVars "${self}/config/direnv/direnvrc.sh" { sha1sum = "${pkgs.perl}/bin/shasum"; }
    );
  };

  xdg.configFile = {
    "bash/functions".source = "${self}/config/bash/functions";
    "inputrc".source = "${self}/config/readline/dot-inputrc";
    "bat/config".source = "${self}/config/bat/config";
    "starship.toml".source = "${self}/config/starship/default.toml";
    "atuin/config.toml".source = "${self}/config/atuin/config.toml";
    "xxh/config.xxhc".source = "${self}/config/xxh/config.xxhc";
  };

  age.secrets = {
    # Using encrypted configuration file since it contains GitHub Gist token
    "config-pet-loic" = {
      file = "${self}/secrets/config-pet-loic.toml.age";
      path = "${config.xdg.configHome}/pet/config.toml";
    };
  };

}

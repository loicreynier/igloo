{
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  # -- Activation
  programs.atuin = {
    enable = true;
    enableBashIntegration = !config.programs.fzf.enable;
  };

  # -- Configuration file
  xdg.configFile."atuin/config.toml".source = "${self}/config/atuin/config.toml";

  # -- fzf integration
  programs.bash.initExtra =
    with lib;
    let
      atuinBin = "${config.programs.atuin.package}/bin/atuin";
      fzfBin = "${config.programs.fzf.package}/bin/fzf";
      # Custom setup function
      fzfSetup =
        builtins.replaceStrings
          [
            "atuin_bin=\"atuin\""
            "fzf_bin=\"fzf\""
          ]
          [
            "atuin=\"${atuinBin}\""
            "fzf_bin=\"${fzfBin}\""
          ]
          (lib.strings.fileContents "${self}/config/bash/functions/fzf-atuin-setup.bash");
      # Init prologue from Home Manager Atuin module
      atuinSetup = ''
        if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
          source "${pkgs.bash-preexec}/share/bash/bash-preexec.sh"
        fi

        __atuin_fzf_history_setup
      '';
    in
    mkIf config.programs.fzf.enable (
      mkOrder 500 (
        strings.concatStringsSep "\n" [
          fzfSetup
          atuinSetup
        ]
      )
    );
}

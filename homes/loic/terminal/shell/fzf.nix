{
  config,
  pkgs,
  ...
}: let
  fzfBin = "${config.programs.fzf.package}/bin/fzf";
  batBin = "${pkgs.bat}/bin/bat";
  justBin = "${pkgs.just}/bin/just";
in {
  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --strip-cwd-prefix";
  };

  home = {
    shellAliases = {
      v = "${fzfBin} --multi --bind 'enter:become(vi {+})' --preview '${batBin} --color=always {}' --height 40% --layout reverse";
    };
    sessionVariables = {
      JUST_CHOOSER = builtins.concatStringsSep " " [
        fzfBin
        "--border=top"
        "--border-label='Parameterless Just recipes'"
        "--height=40%"
        "--margin='5%,0%,5%,0%'"
        "--preview-window=right:85%:wrap:nocycle"
        "--preview='${justBin} --show {} | ${batBin} --language=Just --color=always --style=plain'"
        "--bind=ctrl-u:preview-page-up,ctrl-d:preview-page-down"
        "|| false"
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  ezabin = "${config.programs.eza.package}/bin/eza";
  fdBin = "${config.programs.fd.package}/bin/fd";
  fdCmd = "${fdBin} --type f --hidden --follow --strip-cwd-prefix";
  fzfBin = "${config.programs.fzf.package}/bin/fzf";
  batBin = "${pkgs.bat}/bin/bat --theme=\\\"Visual Studio Dark+\\\""; # TODO: better theme handling
  justBin = "${pkgs.just}/bin/just";
in {
  # -- Commands configurations
  programs.fzf = {
    enable = true;
    defaultCommand = fdCmd;
    historyWidgetOptions = [
      "--height 40%"
      "--preview 'echo {}'"
      "--preview-window down:3:hidden:wrap"
      "--reverse"
      "--bind 'ctrl-space:toggle-preview'"
      # "--bind 'ctrl-y:execute-silent(echo -n {2..} | win32yank.exe -i)+abort'" # TODO
      "--color header:italic"
      "--header 'Press <CTRL-Space> to preview command'" # and <CTRL-y> to copy command into clipboard'"
    ];
    fileWidgetCommand = fdCmd;
    fileWidgetOptions = [
      "--multi"
      "--height 40%"
      "--preview '${batBin} --color=always --style=plain {}'"
      "--reverse"
      "--bind 'alt-u:preview-page-up,alt-d:preview-page-down'"
      # TODO: add copy bind here too
    ];
    changeDirWidgetCommand = "${fdBin} --type d";
    changeDirWidgetOptions = [
      "--height 40%"
      "--reverse"
      "--preview '${ezabin} -a --icons --group-directories-first --color=always {}'"
      "--bind 'alt-u:preview-page-up,alt-d:preview-page-down'"
      # TODO: add copy bind here too
    ];
  };

  # -- Custom commands/functions
  programs.bash.initExtra =
    builtins.replaceStrings [
      "bat_bin=\"bat\""
      "fzf_bin=\"fzf\""
    ]
    [
      "bat_bin=\"${batBin}\""
      "fzf_bin=\"${fzfBin}\""
    ]
    (lib.strings.fileContents "${self}/config/bash/functions/fzf-v.bash");

  # -- Configuration for other tools using `fzf`
  home = {
    sessionVariables = {
      JUST_CHOOSER = builtins.concatStringsSep " " [
        fzfBin
        "--height 40%"
        "--preview-window right:85%:wrap:nocycle"
        "--preview '${justBin} --show {} | ${batBin} --language=Just --color=always --style=plain'"
        "--reverse"
        "--bind 'alt-u:preview-page-up,alt-d:preview-page-down'"
        "|| false"
      ];
    };
  };
}

{
  config,
  pkgs,
  ...
}: {
  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --strip-cwd-prefix";
  };

  home.shellAliases = let
    fzfBin = "${config.programs.fzf.package}/bin/fzf";
    batBin = "${pkgs.bat}/bin/bat";
  in {
    v = "${fzfBin} --multi --bind 'enter:become(vi {+})' --preview '${batBin} --color=always {}' --height 40% --layout reverse";
  };
}

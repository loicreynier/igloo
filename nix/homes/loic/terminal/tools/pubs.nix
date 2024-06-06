{
  lib,
  config,
  pkgs,
  self,
  ...
}: let
  # -- Pubs and bibliography paths
  pubs = "${config.programs.pubs.package}/bin/pubs";
  pubsPathHome = ".pubs";
  pubsPath = "${config.home.homeDirectory}/${pubsPathHome}";
  bibPath = "${config.home.homeDirectory}/Code/Documents/bibliography";

  # -- Pubs scripts
  fzfOpen =
    pkgs.writeShellScriptBin "pubs-fzf-open"
    (builtins.replaceStrings
      [
        "#!/usr/bin/env sh\n"
        "pubs"
        "fzf"
      ]
      [
        ""
        pubs
        "${config.programs.fzf.package}/bin/fzf"
      ]
      (lib.strings.fileContents "${self}/bin/pubs-fzf-open.sh"));

  fzfExport = let
    fdBin = "${config.programs.fd.package}/bin/fd";
    fzfBin = "${config.programs.fzf.package}/bin/fzf";
    batBin = "${pkgs.bat}/bin/bat";
  in
    pkgs.writeShellScriptBin "pubs-fzf-export"
    (builtins.replaceStrings [
        "#!/usr/bin/env sh\n"
        "fd_bin=\"fd\""
        "bat_bin=\"bat\""
        "fzf_bin=\"fzf\""
      ]
      [
        ""
        "fd_bin=\"${fdBin}\""
        "bat_bin=\"${batBin}\""
        "fzf_bin=\"${fzfBin}\""
      ]
      (lib.strings.fileContents "${self}/bin/pubs-fzf-export.sh"));

  exportTag =
    pkgs.writeShellScriptBin "pubs-export-tag"
    (builtins.replaceStrings
      [
        "#!/usr/bin/env sh\n"
        "pubs list"
      ]
      [
        ""
        "${pubs} list"
      ]
      (lib.strings.fileContents "${self}/bin/pubs-export-tag.sh"));
in {
  programs.pubs = {
    enable = true;
    extraConfig = ''
      [main]
      pubsdir = ${pubsPath}
      docsdir = ${pubsPath}/docs
      doc_add = link
      note_extension = md
      open_cmd = ${pkgs.wsl-open}/bin/wsl-open

      [formatting]
      bold = true
      italics = true
      color = true

      [plugins]
      active = alias

      [[alias]]
      add-doi = !pubs add -D "$1" -k "$2" -d "~/Library/Papers/$2.pdf" -L
      fzf-open = !${fzfOpen}/bin/pubs-fzf-open "$@"
      fopen = fzf-open
      fzf-export = !${fzfExport}/bin/pubs-fzf-export "$@"
      fexport = fzf-export
      export-tag = !${exportTag}/bin/pubs-export-tag "$@"
    '';
  };

  home.file."${pubsPathHome}".source = config.lib.file.mkOutOfStoreSymlink bibPath;
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.bat;
in
{
  options.programs.bat.installExtraSyntaxes = lib.mkOption {
    type = lib.types.bool;
    description = "Whether to install extra syntaxes.";
    default = false;
  };

  config.programs.bat.syntaxes = lib.mkIf cfg.installExtraSyntaxes {
    bbcode = {
      src = pkgs.fetchFromGitHub {
        owner = "chipotle";
        repo = "BBCode";
        rev = "a291a750db9cf5e026a27af812727427edf3bd16";
        hash = "sha256-Y/FVBYIwzi52ZP7alsySD3xJI96X08A+ddWMfrinfvU=";
      };
      file = "BBCode.sublime-syntax";
    };
    coconut = {
      src = pkgs.fetchFromGitHub {
        owner = "loicreynier";
        repo = "sublime-syntaxes-converted";
        rev = "94ff11239a9485f2c27b91ca682c6dddfa8d67fb";
        hash = "sha256-H4YNngh7WuXHuIp3eFhYZWPOIVjoK8UYifOUx5OIHFo=";
      };
      file = "syntaxes/coconut.sublime-syntax";
    };
    cuda = {
      src = pkgs.fetchFromGitHub {
        owner = "loicreynier";
        repo = "sublime-syntaxes-converted";
        rev = "94ff11239a9485f2c27b91ca682c6dddfa8d67fb";
        hash = "sha256-H4YNngh7WuXHuIp3eFhYZWPOIVjoK8UYifOUx5OIHFo=";
      };
      file = "syntaxes/cuda-c++.sublime-syntax";
    };
    just = {
      src = pkgs.fetchFromGitHub {
        owner = "nk9";
        repo = "just_sublime";
        rev = "08bbc62e9e77c82fb0fa6cabc0630cb5cc4bcd0e";
        hash = "sha256-wSZe0uklnH3SooFR8RqAeGj3WL3W2cqNeSH/nQS3/4s=";
      };
      file = "Syntax/Just.sublime-syntax";
    };
    gleam = {
      src = pkgs.fetchFromGitHub {
        owner = "molnarmark";
        repo = "sublime-gleam";
        rev = "2e761cdb1a87539d827987f997a20a35efd68aa9";
        hash = "sha256-Zj2DKTcO1t9g18qsNKtpHKElbRSc9nBRE2QBzRn9+qs=";
      };
      file = "syntax/gleam.sublime-syntax";
    };
    odin = {
      src = pkgs.fetchFromGitHub {
        owner = "odin-lang";
        repo = "sublime-odin";
        rev = "c4b626f17c97542c922b55a33618aa953cff4771";
        hash = "sha256-PTYbDNNnnRhiz2Alon/2IEyBaCTIgFThb8gleNq/hbM=";
      };
      file = "Odin.sublime-syntax";
    };
    numbat = {
      src = pkgs.fetchFromGitHub {
        owner = "sharkdp";
        repo = "numbat";
        rev = "6572a27ee02952b58740a960e73b30da410e392e";
        hash = "sha256-uvh2blo86J9nCsl0y8huaom39Kg2x3XZ7YBEi1kU62E=";
      };
      file = "assets/numbat.sublime-syntax";
    };
    typst = {
      src = pkgs.fetchFromGitHub {
        owner = "hyrious";
        repo = "typst-syntax-highlight";
        rev = "4f7f30d7ee52987f2e219ad42c47cf7aca3a62ef";
        hash = "sha256-WuW4HfKmgEl/drEt1urhDjCdTuKGbtWiVDdZt84lcOY=";
      };
      file = "Typst.sublime-syntax";
    };
  };
}

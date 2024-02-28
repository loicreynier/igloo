{
  config,
  lib,
  pkgs,
}:
with lib; let
  cfg = config.programs.xonsh;
in {
  meta.maintainers = [maintainers.loicreynier];

  options = {
    programs.xonsh = {
      enable = mkEnableOption "Xonsh shell";

      package = mkPackageOption pkgs "xonsh" {
        example = "xonsh.override { extraPackages = ps: [ ps.numpy ];}";
      };
    };
  };

  config = mkIf cfg.enable {
    home.file.".xonshrc" = {};

    home.packages = [
      cfg.package
    ];
  };
}

{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.igloo.device = {
    type = mkOption {
      type = types.enum [
        "laptop"
        "desktop"
        "server"
        "workstation"
        "wsl"
      ];
      default = "";
      description = ''
        The type/purpose that will be used within the rest of the configuration:
          - laptop: portable device with graphical interface
          - desktop: stationary device with graphical interface
          - server: stationary device without graphical interface
          - workstation: provide both desktop & server functionality
          - wsl: Windows Subsystem for Linux
      '';
    };
  };
}

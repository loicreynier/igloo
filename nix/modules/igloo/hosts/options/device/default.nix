{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.igloo.device = {
    type = mkOption {
      type = types.enum [
        "laptop"
        "desktop"
        "server"
        "workstation"
        "wsl"
        "iso"
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

    gpu = {
      type = mkOption {
        type =
          with types;
          nullOr (enum [
            "intel"
            "amd"
            "nvidia"
          ]);
        default = null;
        description = ''
          The manifacturer/type of the primary system GPU.
          Allows the correct GPU settings and drivers to be loaded,
          potentially optimizing video output performance.
        '';
      };
    };
  };

  config.assertions = [
    {
      assertion = config.igloo.device.type != "";
      message = ''
        ${config.networking.hostName} is missing a device type: 'config.igloo.device.type' must be defined
      '';
    }
  ];
}

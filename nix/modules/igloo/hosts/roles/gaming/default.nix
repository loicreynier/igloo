{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  environment.systemPackages = with pkgs; [
    piper
    gamepad-tool

    protonplus
  ];

  services = {
    ratbagd.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # Try to make Bluetooth Xbox controllers work
      settings = {
        General = {
          Privacy = "device";
          JustWorksRepairing = "always";
          Class = "0x000100";
          FastConnectable = "true";
        };
      };
    };
    xpadneo.enable = true;
  };
}

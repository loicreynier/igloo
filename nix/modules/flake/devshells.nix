{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devshells.default.devshell = {
        motd = "{bold}❄️ 🐧 Welcome to Igloo's devshell 🐧❄️{reset}";
        # $(type -p menu &>/dev/null && menu)
        packages = with pkgs; [
          mise
          dotbot
        ];
      };
    };
}

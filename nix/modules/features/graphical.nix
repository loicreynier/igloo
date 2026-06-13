{
  flake.nixosModules.graphical =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        firefox
        parsec-bin
        thunderbird
        vlc
      ];

      fonts = {
        packages = with pkgs; [
          nerd-fonts.fira-code
          nerd-fonts.droid-sans-mono
          nerd-fonts.sauce-code-pro
        ];
      };
    };
}

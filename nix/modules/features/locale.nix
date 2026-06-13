{
  flake.nixosModules.base = { lib, ... }: {
    time.timeZone = lib.mkDefault "Europe/Paris";

    console.keyMap = lib.mkDefault "fr";

    services.xserver.xkb = {
      layout = lib.mkDefault "fr";
      variant = lib.mkDefault "";
    };

    i18n =
      let
        enLocale = "en_US.UTF-8";
        frLocale = "fr_FR.UTF-8";
      in
      {
        # Fixes diacritics (ï) on Wayland by letting IBus handles dead keys
        inputMethod = {
          enable = true;
          type = "ibus";
        };

        defaultLocale = enLocale;

        extraLocaleSettings = {
          LANG = enLocale;
          LC_CTYPE = enLocale;
          LC_COLLATE = enLocale;
          LC_MESSAGES = enLocale;

          LC_ADDRESS = lib.mkDefault frLocale;
          LC_IDENTIFICATION = lib.mkDefault frLocale;
          LC_MEASUREMENT = lib.mkDefault frLocale;
          LC_MONETARY = lib.mkDefault frLocale;
          LC_NAME = lib.mkDefault frLocale;
          LC_NUMERIC = lib.mkDefault frLocale;
          LC_PAPER = lib.mkDefault frLocale;
          LC_TELEPHONE = lib.mkDefault frLocale;
          LC_TIME = lib.mkDefault frLocale;
        };

        supportedLocales = lib.mkDefault [
          "${frLocale}/UTF-8"
          "${enLocale}/UTF-8"
        ];
      };
  };
}

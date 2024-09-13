{lib, ...}: {
  console.keyMap = lib.mkDefault "fr";

  services.xserver.xkb = {
    layout = lib.mkDefault "fr";
    variant = lib.mkDefault "";
  };

  i18n = let
    defaultLocale = "en_US.UTF-8";
    frLocale = "fr_FR.UTF-8";
  in {
    inherit defaultLocale;

    extraLocaleSettings = {
      LANG = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_MESSAGES = defaultLocale;

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
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
  };

  time.timeZone = lib.mkDefault "Europe/Paris";
}

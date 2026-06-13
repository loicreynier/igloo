let
  userPkgs =
    pkgs: with pkgs; [
      curl
      file
      fd
      git
      gnutar
      neovim
      openssh
      ripgrep
      rsync
      wget
      zip
      unzip
    ];
  adminPkgs =
    pkgs: with pkgs; [
      pciutils
      util-linux
      kmon
    ];
in
{
  flake.nixosModules.base = { pkgs, ... }: {
    environment.systemPackages = (userPkgs pkgs) ++ (adminPkgs pkgs);

    programs = {
      gnupg.agent.enable = true;
    };

    services = {
      openssh.enable = true;
    };
  };

  flake.module.home.base = { pkgs, ... }: {
    home.packages = userPkgs pkgs;
  };
}

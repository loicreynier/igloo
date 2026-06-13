let
  nixPrograms =
    pkgs: with pkgs; [
      nh
    ];
in
{
  flake.nixosModules.base = { pkgs, lib, ... }: {
    nix = {
      settings = {
        system-features = [
          "kvm"
          "big-parallel"
          "nixos-test"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        trusted-users = [
          "root"
          "nixos"
          "@wheel"
        ];
        auto-optimise-store = lib.mkDefault true;
        warn-dirty = false;
      };
    };

    documentation = {
      nixos.enable = true;
      man = {
        enable = true;
        cache.enable = true;
      };
      doc.enable = false; # Don't install HTML in `/share/doc`
      info.enable = false;
    };

    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
        "parsec-bin"
      ];

    programs = {
      nix-ld.enable = true;
    };

    environment.systemPackages = nixPrograms pkgs;
  };

  flake.homeModules.base = { pkgs, ... }: {
    home.packages = nixPrograms pkgs;
  };
}

{
  lib,
  pkgs,
  ...
}:
{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "nixos"
        "@wheel"
      ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      system-features = [
        "kvm"
        "big-parallel"
        "nixos-test"
      ];
      # Make all commands work with flakes
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      # FIXME: unsafe option
      # https://github.com/NixOS/nix/issues/4265
      # https://github.com/purenix-org/purenix/issues/34
      allow-import-from-derivation = "true";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # TODO: configure to run after `gc`
    optimise = {
      automatic = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Filter documentation build to reduce bloat
  documentation = {
    doc.enable = false; # No HTML
    nixos.enable = true;
    info.enable = false;
    man = {
      enable = lib.mkDefault true;
      generateCaches = lib.mkDefault true;
    };
  };

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    nh
    nps
    manix
  ];
}

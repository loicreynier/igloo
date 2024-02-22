full-switch:
    igloo-nixos-switch
    igloo-home-switch

switch-home:
    igloo-home-switch

switch-nixos:
    igloo-nixos-switch

build-home:
    igloo-home-build

build-nixos:
    igloo-nixos-build

build-readme:
    sh .github/make-readme.sh

show:
    nix flake show --allow-import-from-derivation

update:
    igloo-update

check:
    nix flake check

clean: clean-result clean-store

clean-result:
    find . -name result -delete

clean-store:
    nix store gc
    nix store optimise

# Run full switch: home + system
full-switch: switch-nixos switch-home

# Build home and switch
switch-home:
    igloo-switch-home

# Build system and switch
switch-nixos:
    igloo-switch-nixos

# Build home
build-home:
    igloo-build-home

# Build system
build-nixos:
    igloo-build-nixos

# Build GitHub README
build-readme:
    sh .github/make-readme.sh

# Show flake outputs
show:
    nix flake show --allow-import-from-derivation

# Show TODO-s and FIXME-s:
todo:
    @rg -g '!Justfile' TODO
    @rg -g '!Justfile' FIXME

# Update flake inputs
update:
    igloo-update

# Run flake checks
check:
    nix flake check

# Run full clean: Nix store + repo
clean: clean-result clean-store

# Clean repo from results links
clean-result:
    find . -name result -delete

# Clean Nix store
clean-store:
    nix store gc
    nix store optimise

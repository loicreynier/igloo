alias sh := switch-home
alias sn := switch-nixos
alias bh := build
alias bn := build-nixos
alias s := switch
alias b := build
alias ls := show
alias u := update

# Run full switch: home + system
switch: switch-nixos switch-home

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

# Build all
build: build-nixos build-home

# Build WSL system tarball
build-wsl system="smaug":
    @mkdir -p build
    @echo 'Building "{{ system }}" WSL system tarball'
    sudo nix run .#nixosConfigurations.{{ system }}-wsl.config.system.build.tarballBuilder
    @mv -v nixos-wsl.tar.gz \
        build/nixos-wsl-{{ system }}_\
        "$(git rev-parse --abbrev-ref HEAD)"-\
        "$(git describe --always --dirty --tags --abbrev=7)".tar.gz

# Build GitHub README
build-readme:
    sh .github/make-readme.sh

# Show flake outputs
show:
    nix flake show --allow-import-from-derivation

# Show flake outputs with `nix-schema`
show-schema:
    nix-schema flake show

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

# Run pre-commit checks
pre-commit:
    pre-commit run

# Check code
check-code:
    pre-commit run --all-files

# Run full clean: Nix store + repo
clean: clean-result clean-store

# Clean repo from results links
clean-result:
    find . -name result -delete

# Clean Nix store
clean-store:
    nix store gc
    nix store optimise

# shellcheck disable=SC2148
nix flake update && git commit flake.lock -m "build(flake): update inputs"


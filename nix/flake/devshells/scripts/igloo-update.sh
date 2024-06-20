# shellcheck disable=SC2148
nix flake update &&
  nix flake check &&
  git commit flake.lock -m "build(flake): update inputs"

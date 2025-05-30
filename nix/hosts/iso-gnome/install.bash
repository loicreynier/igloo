#!/usr/bin/env bash

set -euo pipefail
shopt -s extglob nullglob

igloo_git_url="https://github.com/loicreynier/igloo"
igloo_path="$HOME/.igloo"

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Error: $(basename "$0") should be run as a regular user."
  exit 1
fi

if [[ ! -d "$igloo_path/.git" ]]; then
  git clone "$igloo_git_url" "$igloo_path"
fi

# shellcheck disable=2012
target=$(\ls -1 "${igloo_path}/nix/hosts/"!(iso-*|*-wsl)/default.nix | cut -d'/' -f7 | gum choose)

sudo nixos-install --flake "${igloo_path}#${target}"

# shellcheck disable=SC2148
sudo nixos-rebuild switch "$@" --flake ".#$HOSTNAME"

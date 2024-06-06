# shellcheck disable=SC2148
nixos-rebuild build "$@" --flake ".#$HOSTNAME"

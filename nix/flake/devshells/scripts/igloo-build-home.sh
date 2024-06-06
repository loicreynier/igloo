# shellcheck disable=SC2148
home-manager build "$@" --flake \
  .#"$USER$([[ "$(</proc/version)" =~ 'WSL' ]] && echo '@wsl')"

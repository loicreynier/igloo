# shellcheck disable=SC2148
home-manager switch "$@" -b bak --flake \
  .#"$USER$([[ "$(</proc/version)" =~ 'WSL' ]] && echo '@wsl')"

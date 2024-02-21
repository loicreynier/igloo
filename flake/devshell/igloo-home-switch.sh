# shellcheck disable=SC2148
home-manager switch --flake \
    .#"$USER$([[ "$(< /proc/version)" =~ 'WSL' ]] && echo '@wsl')"


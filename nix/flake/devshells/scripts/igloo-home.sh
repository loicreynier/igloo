# shellcheck disable=SC2148

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <command> [<args>...]"
  echo "Commands: build, switch"
  exit 1
fi

command=$1
shift

if [[ $command != "switch" && $command != "build" ]]; then
  echo "Invalid command: $command"
  echo "Commands: switch, build"
  exit 1
fi

hostnames=(latios)

if [[ "$(</proc/version)" =~ 'WSL' ]]; then
  home="$USER@wsl"
else
  if [[ " ${hostnames[*]} " =~ $HOSTNAME ]]; then
    home="loic@$HOSTNAME"
  else
    home="loic"
  fi
fi

home-manager "$command" "$@" -b bak --flake ".#$home"

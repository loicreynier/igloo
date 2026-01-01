# vim: ft=bash
# shellcheck shell=bash
#
# -- Customizing cache location
#
# Create human-readable per-project cache directories
# Source: https://github.com/direnv/direnv/wiki/Customizing-cache-location
: "${XDG_CACHE_HOME:="${HOME}/.cache"}"
declare -A direnv_layout_dirs
direnv_layout_dir() {
  local hash path
  echo "${direnv_layout_dirs[$PWD]:=$(
    hash="$(command sha1sum - <<<"$PWD" | head -c40)"
    path="${PWD//[^a-zA-Z0-9]/-}"
    echo "${XDG_CACHE_HOME}/direnv/layouts/${hash}${path}"
  )}"
}

# -- Daemonize
#
# Sauce: https://github.com/direnv/direnv/wiki/Daemonize
#
# Usage: daemonize <name> [<command> [...<args>]]
#
# Starts the command in the background with an exclusive lock on `$name`.
# If no command is passed, it uses the name as the command.
# Logs are in `$name.log` in the corresponding cache directory.
# To kill the process, run `kill $(< .direnv/$name.pid)`.
daemonize() {
  local name pid_file log_file
  name=$1
  shift
  pid_file=$(direnv_layout_dir)/$name.pid
  log_file=$(direnv_layout_dir)/$name.log

  if [[ $# -lt 1 ]]; then
    cmd=$name
  else
    cmd=$1
    shift
  fi

  if ! has "$cmd"; then
    echo "Error: $cmd not found"
    return 1
  fi

  mkdir -p "$(direnv_layout_dir)"

  exec 200>"$pid_file"

  if ! flock --nonblock 200; then
    echo "daemonize[$name] is already running as pid $(<"$pid_file")"
    return
  fi

  # Start the process in the background: require two forks to escape the control of Bash.
  (
    (
      echo "daemonize[$name:$BASHPID]: starting $cmd $*" >&2
      echo "$BASHPID" >&200

      exec 0</dev/null
      exec 1>"$log_file"
      exec 2>&1
      exec 3>&-
      exec 4>&-
      exec "$cmd" "$@"
    ) &
  ) &

  exec 200>&-
}

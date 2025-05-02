#!/usr/bin/env bash

# TODO: add Zoxide completion

if ! command -v zoxide >/dev/null 2>&1; then
  return 1
fi

function __igloo_pushz_print_help() {
  echo -n "Usage: pushz" >&2
  echo -n ' [<pushd-flag>] [-h | --help] [--debug]' >&2
  echo ' [--] [<z-argument>...]' >&2
  echo
  echo 'Options:'
  echo -e "\t pushd-flag\n\t\t Adds a flag to send to \`pushd\`. Must begin with a hyphen."
  echo -e "\t z-argument\n\t\t Adds an argument to send to \`z\`"
  echo -e "\t -h, --help\n\t\t Displays this help message"
  echo -e "\t --debug\n\t\t Halts evaluation of \`pushz\` after option interpretation."
  echo -e "\t\t Displays arguments that would be used."
}

function pushz() {
  local origin="$PWD"
  local target=""
  local pushd_flags=()
  local z_args=()

  local debug=false
  local eval_args=true

  for arg in "$@"; do
    if [[ $eval_args == false ]]; then
      z_args+=("$arg")
    elif [[ $arg == "--" ]]; then
      eval_args=false
    elif [[ $arg == "-h" || $arg == "--help" ]]; then
      __igloo_pushz_print_help
      return 0
    elif [[ $arg == "--debug" ]]; then
      debug=true
    elif [[ $arg =~ [-\+][0-9]+ ]]; then
      # shellcheck disable=2016
      echo 'Error: the `-+{N}` operator is not supported' 1>&2
      return 1
    elif [[ $arg == -* ]]; then
      pushd_flags+=("$arg")
    else
      z_args+=("$arg")
      eval_args=false
    fi
  done

  if [[ $debug == true ]]; then
    echo "origin=${origin}"
    echo "pushd_flags=$(printf '%q ' "${pushd_flags[@]}")"
    echo "z_args=$(printf '%q ' "${z_args[@]}")"
    return 0
  fi

  z "${z_args[@]}" && {
    target="$PWD"
    builtin cd "$origin" || exit 1
    builtin pushd "${pushd_flags[@]}" "$target" || exit 1
  }
}

alias popz=popd

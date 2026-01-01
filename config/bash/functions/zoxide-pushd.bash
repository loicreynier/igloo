#!/usr/bin/env bash

if ! command -v zoxide >/dev/null 2>&1; then
  return 1
fi

function __zoxide_pushz_print_help() {
  echo -n "Usage: pushz/pushzi" >&2
  echo -n " [<pushd-flag>] [-h | --help] [--debug]" >&2
  echo " [--] [<z/zi-argument>...]" >&2
  echo
  echo 'Options:'
  echo -e "\t pushd-flag\n\t\t Adds a flag to send to \`pushd\`. Must begin with a hyphen."
  echo -e "\t z/zi-argument\n\t\t Adds an argument to send to \`z\`"
  echo -e "\t -h, --help\n\t\t Displays this help message"
  echo -e "\t --debug\n\t\t Halts evaluation of \`pushz\` after option interpretation."
  echo -e "\t\t Displays arguments that would be used."
}

function __zoxide_pushzi_print_help() {
  echo -n "Usage: pushzi" >&2
  echo -n ' [<pushd-flag>] [-h | --help]' >&2
}

function pushz() {
  if [[ $# -eq 0 ]]; then
    builtin pushd || return 1
    return $?
  fi

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
      __zoxide_pushz_print_help
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

function pushzi() {
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
      __zoxide_pushzi_print_help
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

  zi "${z_args[@]}" && {
    target="$PWD"
    builtin cd "$origin" || exit 1
    builtin pushd "${pushd_flags[@]}" "$target" || exit 1
  }
}

alias popz=popd
complete -o filenames -F __zoxide_z_complete pushz

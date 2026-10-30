#!/usr/bin/env bash

# Custom glibc install loader wrapper script

set -e

GLIBEXEC_PREFIX="${GLIBEXEC_PREFIX:-$HOME/.local/opt/glibc}"
GLIBEXEC_PRINT_CMD="${GLIBEXEC_PRINT_CMD:-0}"

# -- Usage "library" and helpers

_usage_name="glibexec" # Program name
_usage_opt_width=17    # Longest option width

if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
    _usage_bgreen=$'\e[1;32m'
    _usage_bcyan=$'\e[1;36m'
    _usage_cyan=$'\e[36m'
    _usage_bred=$'\e[1;31m'
    _usage_nocolor=$'\e[0m'
else
    _usage_bgreen=''
    _usage_bcyan=''
    _usage_cyan=''
    _usage_bred=''
    _usage_nocolor=''
fi

_usage_opt_width=${_usage_opt_width:-30}

_usage_usage() {
  printf "%sUsage:%s %s%s %s%s\n" \
    "$_usage_bgreen" "$_usage_nocolor" "$_usage_bcyan$1$_usage_nocolor" "$_usage_cyan" "$2" "$_usage_nocolor"
}

_usage_section() {
  printf "%s%s%s\n" "$_usage_bgreen" "$1" "$_usage_nocolor"
}

_usage_opt() {
  # $1 = short option ("" if none)
  # $2 = long option ("" if none)
  # $3 = param ("" if none)
  # $4 = description
  local short=$1
  long=$2
  param=$3
  desc=$4
  local pad=0
  local display=''

  case $short in
  '') ;;
  *) display="${_usage_bcyan}${short}${_usage_nocolor}" ;;
  esac
  case $long in
  '') ;;
  *)
    [ -n "$short" ] && display="${display}${_usage_nocolor}, "
    display="${display}${_usage_bcyan}${long}${_usage_nocolor}"
    ;;
  esac
  case $param in
  '') ;;
  *)
    display="${display} ${_usage_cyan}${param}${_usage_nocolor}"
    pad=1
    ;;
  esac

  width=$((${#short} + ${#long} + ${#param} + pad))
  [[ -n $short ]] && [[ -n $long ]] && width=$((width + 2)) # ", "

  printf '  %s%*s%s\n' "$display" "$((_usage_opt_width - width))" '' "$desc"
}

_usage_error() {
  printf '%sError:%s %s\n' "$_usage_bred" "$_usage_nocolor" "$1"
}

print_error() {
  _usage_error "$1" >&2
}

print_help() {
  cat <<EOF
Run a program linked to a custom GNU C library (glibc) install.

EOF
  print_usage
}

print_usage() {
  _usage_usage "$_usage_name" "[--prefix=<path>] [--print-cmd] <command> [<args>]"
  echo
  _usage_section "Options:"
  _usage_opt "" "--prefix" "<path>" \
    "Specify custom glibc installation directory [env: GLIBEXEC_PREFIX=, default: $HOME/.local/opt/glibc]"
  _usage_opt "" "--print-cmd" "" \
    "Print full path of the resolved command and exit [env: GLIBEXEC_PRINT_CMD=1]"
  _usage_opt "-h" "--help" "" "Show this help message and exit"
  echo
  _usage_section "Examples:"
  echo "  $_usage_name --prefix ~/.local/stow/glibc-2.30 <command> [<args>]"
  echo "  $_usage_name --print-cmd <command>"
}

# -- Argument parsing

while [[ $1 =~ ^- ]]; do
  case "$1" in
  --prefix)
    shift
    GLIBEXEC_PREFIX="$1"
    ;;
  --print-cmd)
    GLIBEXEC_PRINT_CMD=1
    ;;
  -h | --help)
    print_usage
    exit 0
    ;;
  *)
    print_error "unknown option: $1"
    echo >&2
    print_usage >&2
    exit 1
    ;;
  esac
  shift
done

if [[ -z $1 ]]; then
  print_error "no command specified"
  echo >&2
  print_usage >&2
  exit 1
fi

# -- Script

# Resolve the command to an absolute path as loader doesn't know `$PATH`
cmd=$(command -v "$1") || {
  print_error "command not found: $1"
  exit 1
}

if [[ $GLIBEXEC_PRINT_CMD -eq 1 ]]; then
  echo "$cmd"
  exit 0
fi

shift

arch=$(uname -m)
case "$arch" in
x86_64)
  loader_basename="ld-linux-x86-64.so.2"
  ;;
aarch64)
  loader_basename="ld-linux-aarch64.so.1"
  ;;
i386 | i486 | i586 | i686)
  loader_basename="ld-linux.so.2"
  ;;
*)
  print_error "unsupported architecture: $arch"
  exit 1
  ;;
esac

loader=""
for dir in \
  "$GLIBC_PREFIX/lib64" \
  "$GLIBC_PREFIX/lib"; do
  if [[ -x "$dir/$loader_basename" ]]; then
    loader="$dir/$loader_basename"
    break
  fi
done

if [[ ! -x $loader ]]; then
  print_error "'$loader' not found or not executable"
  exit 1
fi

exec "$loader" \
  --library-path "$GLIBEXEC_PREFIX/lib:/lib:/lib64:/usr/lib:/usr/lib64" \
  "$cmd" "$@"

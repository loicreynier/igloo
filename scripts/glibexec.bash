#!/usr/bin/env bash

# Run program linked to a custom glibc install

name="glibexec"

GLIBC_PREFIX="$HOME/.local/opt/glibc"

print_usage() {
  echo "Usage: glibexec [--glibc-path </path/to/glibc>] command [args...]"
  echo
  echo "Options:"
  echo "  --glibc-path PATH   Specify custom glibc installation directory"
  echo "                      (default: $HOME/.local/opt/glibc)"
  echo "  -h, --help          Show this help message and exit"
  echo
  echo "Example:"
  echo "  $name --glibc-path ~/.local/stow/glibc-2.30 mise --flag arg"
}

while [[ $1 =~ ^- ]]; do
  case "$1" in
  --glibc-path)
    shift
    GLIBC_PREFIX="$1"
    ;;
  -h | --help)
    print_usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    print_usage
    exit 1
    ;;
  esac
  shift
done

if [[ -z $1 ]]; then
  echo "Error: no command specified"
  print_usage
  exit 1
fi

# Resolve the command to an absolute path as loader doesn't know `$PATH`
cmd=$(command -v "$1") || {
  echo "Command not found: $1"
  exit 1
}
shift

arch=$(uname -m)
case "$arch" in
x86_64)
  loader="$GLIBC_PREFIX/lib/ld-linux-x86-64.so.2"
  ;;
aarch64)
  loader="$GLIBC_PREFIX/lib/ld-linux-aarch64.so.1"
  ;;
*)
  echo "Unsupported architecture: $arch"
  exit 1
  ;;
esac

if [[ ! -x $loader ]]; then
  echo "Error: '$loader' not found or not executable"
  exit 1
fi

exec "$loader" \
  --library-path "$GLIBC_PREFIX/lib:/lib:/lib64:/usr/lib:/usr/lib64" \
  "$cmd" "$@"

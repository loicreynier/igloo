#!/usr/bin/env sh

MISE_DATA_DIR=${MISE_DATA_DIR:-$HOME/.local/opt/mise}
MISE_INSTALL_PATH=${MISE_INSTALL_PATH:-$HOME/.local/bin/mise}

print_usage() {
  echo "Usage: $0 [--help] [--path <path/to/mise/bin>]"
  echo
  echo "Options:"
  echo
  echo " --path MISE_INSTALL_PATH   Mise binary install path"
  echo "                            (default: $MISE_INSTALL_PATH)"
  echo " --help                     Print this help message and exit"
}

while [ $# -gt 0 ]; do
  case "$1" in
  --help)
    print_usage
    exit 0
    ;;
  *)
    echo "Unknown option: '$1'" >&2
    print_usage
    exit 1
    ;;
  esac

done

curl --proto "=https" --tlsv1.2 -sSf https://mise.run |
  MISE_INSTALL_PATH="$MISE_INSTALL_PATH" MISE_DATA_DIR=$MISE_DATA_DIR sh

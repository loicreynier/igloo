#!/usr/bin/env sh

CARGO_HOME=${CARGO_HOME:-$HOME/.local/opt/cargo}
RUSTUP_HOME=${RUSTUP_HOME:-$HOME/.local/opt/rustup}
export CARGO_HOME RUSTUP_HOME

RUSTUP_PROFILE=${RUSTUP_PROFILE:-default}

print_usage() {
  echo "Usage: $0 [--help] [--profile <minimal|default>]"
  echo
  echo "Options:"
  echo
  echo "  --profile RUSTUP_PROFILE    Specify the installation profile"
  echo "                              Minimal: rustc/cargo"
  echo "                              Default: rustc/cargo/clippy/rustfmt"
  echo "  --help                      Print this help message and exit"
}

while [ $# -gt 0 ]; do
  case "$1" in
  --help)
    print_usage
    exit 0
    ;;
  --profile)
    shift
    if [ -n "$1" ]; then
      RUSTUP_PROFILE=$1
      shift
    else
      echo "Error: '--profile' requires a parameter" >&2
      exit 1
    fi
    ;;
  *)
    echo "Unknown option: $1" >&2
    print_usage
    exit 1
    ;;
  esac
done

curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs |
  sh -s -- \
    --no-modify-path \
    --profile "$RUSTUP_PROFILE"

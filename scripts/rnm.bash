#!/usr/bin/env bash

# Rename files without writing the entire renamed path.
#
#   rnm /tmp/foo bar
#   renamed '/tmp/foo' -> '/tmp/bar'
#

name="rnm"

print_usage() {
  echo "Usage: $name [-h | --help] [-f | --force] [-c | --copy] <path> <new-filename>"
  echo
  echo "Options:"
  echo "  -h, --help     Display this help message"
  echo "  -f, --force    Force rename if the new filename already exists"
  echo "  -c, --copy     Copy instead of renaming"
  echo
  echo "Examples:"
  echo "  $name /path/to/foo bar"
}

# Transform long options to short ones for `getopts`
for arg in "$@"; do
  shift
  case "$arg" in
  "--help")
    set -- "$@" "-h"
    ;;
  "--force")
    set -- "$@" "-f"
    ;;
  *)
    set -- "$@" "$arg"
    ;;
  esac
done

# Default behavior
force=false
copy=false
cmd_flags="-v"

while getopts ":hfc" opt; do
  case ${opt} in
  h)
    print_usage
    exit 0
    ;;
  f)
    force=true
    ;;
  c)
    copy=true
    ;;
  *)
    echo "Invalid option: $opt"
    print_usage
    exit 2
    ;;
  esac
done
shift $((OPTIND - 1))

if [ $# -ne 2 ]; then
  print_usage
  exit 1
fi

if [[ $2 == *"/"* ]]; then
  echo "Error: The new filename should not be a path"
  echo
  print_usage
  exit 1
fi

# Parse and convert to absolute paths
# Using `realink` here because it converts to absolute path
# and remove both duplicate and trailing slashing which is tideous in pure Bash.
# Also, it resolve symbolic links which can be useful on a Nix system.
old_filename=$(readlink -n -e "$1")
new_filename=$(readlink -n -m "$(dirname "$old_filename")/$2")

if [ ! -e "$old_filename" ]; then
  echo "Error: File '${old_filename}' does not exist"
  exit 1
fi

if git ls-files --error-unmatch "$old_filename" &>/dev/null; then
  if [ $copy == true ]; then
    cp $cmd_flags "$old_filename" "$new_filename"
    git add "$new_filename"
  else
    git mv $cmd_flags "$old_filename" "$new_filename"
  fi

else
  [ $force == true ] && cmd_flags="$cmd_flags -f"
  if [ $copy == true ]; then
    cp "$cmd_flags" "$old_filename" "$new_filename"
  else
    mv "$cmd_flags" "$old_filename" "$new_filename"
  fi
fi

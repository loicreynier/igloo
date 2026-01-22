#!/usr/bin/env sh

repo="mikepqr/stowsh"
file="stowsh"
DEBUG=${DEBUG:-}

print_usage() {
  echo "Usage: $0 [--help] [--debug]"
  echo
  echo "Install \`stowsh\` as a Stow package and link to '$HOME/.local/bin/stowsh'"
  echo
  echo "Options:"
  echo
  echo "  --help      Show this help message and exit"
  echo "  --debug     Enable debug output"
}

while [ $# -gt 0 ]; do
  case "$1" in
  --help)
    print_usage
    exit 0
    ;;
  --debug)
    DEBUG=1
    shift
    ;;
  *)
    echo "Unknown option: $1" >&2
    print_usage
    exit 1
    ;;
  esac
done

# -- Fetch latest commit SHA and date

if command -v jq >/dev/null 2>&1; then
  read -r sha date <<EOF
$(curl -sSf "https://api.github.com/repos/$repo/commits" |
    jq -r '.[0] | .sha as $s | .commit.committer.date | split("T")[0] as $d | "\($s) \($d)"')
EOF
else
  # Fallback to based AWK script
  read -r sha date <<EOF
$(curl -sSf "https://api.github.com/repos/$repo/commits" |
    awk -F'"' '/"sha"/ {sha=$4} /"date"/ {split($4,d,"T"); print sha, d[1]; exit}')
EOF
fi

[ -n "$DEBUG" ] && echo "DEBUG: sha=$sha date=$date"

if [ -z "$sha" ] || [ -z "$date" ]; then
  echo "Error: failed to parse commit SHA or date from 'github:$repo'" >&2
  exit 1
fi

# -- Download as a Stow package

dest_dir="$HOME/.local/stow/stowsh-git-$date/bin"
mkdir -p "$dest_dir" || {
  echo "Error: failed to create '$dest_dir'" >&2
  exit 1
}
dest="$dest_dir/$file"

echo "Downloading 'stowsh@$sha'..."
if ! curl -sSf "https://raw.githubusercontent.com/$repo/$sha/$file" -o "$dest"; then
  echo "Error: failed to download '$file' from 'github:$repo@$sha'" >&2
  exit 1
fi

chmod +x "$dest" || {
  echo "Error: failed to make '$dest' executable" >&2
  exit 1
}

echo "\`$file\` installed in '$dest'"

# -- Install Stow package

mkdir -p "$HOME/.local/bin" || {
  echo "Error: failed to create '$HOME/.local/bin'" >&2
  exit 1
}

ln -sf "$dest" "$HOME/.local/bin/$file" || {
  echo "Error: failed to link '$file'" >&2
  exit 1
}
echo "\`$file\` linked in '$HOME/.local/bin'"

case ":$PATH:" in
*":$HOME/.local/bin:"*) : ;;
*) echo "Warning: '$HOME/.local/bin' is not in your PATH" ;;
esac

#!/usr/bin/env bash

url="https://raw.githubusercontent.com/mikepqr/stowsh/refs/heads/main/stowsh"
dest="$HOME/.local/bin/stowsh"

mkdir -p "$HOME/.local/bin"
curl -L -o "$dest" "$url"
chmod +x "$dest"

echo "\`stowsh\` installed in $dest"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo "Warning: \$HOME/.local/bin is not in your PATH."
fi

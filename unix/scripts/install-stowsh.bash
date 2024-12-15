#!/usr/bin/env bash

repo="mikepqr/stowsh"
file="stowsh"

read -r sha date <<<"$(curl -s "https://api.github.com/repos/$repo/commits" |
  # Just showing off some AWK scripting
  awk -F'"' '
    /"sha"/ {sha=$4}
    /"date"/ {date=$4; split(date, d, "T"); print sha, d[1]; exit}
  ')"

dest="$HOME/.local/stow/stowsh-git-$date/bin"
mkdir -p "$dest"
dest="$dest/$file"

curl -s "https://raw.githubusercontent.com/$repo/$sha/$file" -o "$dest"
chmod +x "$dest"
echo "\`stowsh\` installed in $dest"

ln -s "$dest" "$HOME/.local/bin" && echo "\`stowsh\` linked in $HOME/.local/bin"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  # shellcheck disable=2016
  echo 'Warning: $HOME/.local/bin is not in your PATH.'
fi

#!/usr/bin/env bash

for cmd in manix fzf bat xargs; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required command '$cmd' not found in PATH." >&2
    exit 1
  fi
done

preview_cmd='
  manix {} | sed "s/type: /> type: /g" | bat --plain
'

manix_list() {
  # Keep only the options attribute name
  manix "" | awk '
    /^# / {
      line = $0
      sub(/^# /, "", line)
      sub(/ \(.*$/, "", line)
      print line
    }
  '
}

manix_list | fzf --ansi --preview="$preview_cmd" | xargs manix

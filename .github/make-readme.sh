#!/usr/bin/env sh

cd "$(dirname "$0")" || exit
# echo "$(basename "$0"): running in $(pwd)"
(
  cat "readme-header.html"
  tail -n +2 "../README.md"
  cat "readme-footer.html"
) | sed "s|(./|(../|g" >"README.md"

#!/usr/bin/env bash

if ! command -v fzf >/dev/null 2>&1; then
  return 1
fi

function pushf() {
  if (($# > 0)); then
    printf "Error: 'pushf' does not take arguments. Use 'pushd' directly instead." >&2
    return 1
  fi

  # Count number of directories in the stack without using `dirs -p | wc -l`, Bash chad mode
  local -a stack=()
  local i=0
  while read -r dir; do
    stack+=("[$i] $dir")
    ((i++))
  done < <(dirs -p)

  if ((${#stack[@]} <= 2)); then
    pushd || return 1
    return
  fi

  local fzf_opts=(
    "--height" "40%"
    "--layout" "reverse"
  )

  local selection
  selection=$(printf "%s\n" "${stack[@]}" | fzf "${fzf_opts[@]}")
  if [[ -n $selection && $selection =~ \[([0-9]+)\] ]]; then
    pushd "+${BASH_REMATCH[1]}" >/dev/null || return 1
  fi
}

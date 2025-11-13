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

  # Just run `pushd` if only two items in the stack
  if ((${#stack[@]} <= 2)); then
    pushd >/dev/null || return 1
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

function __fzf_pushf__() {
  local -a stack=()
  local i=0
  while read -r dir; do
    stack+=("[$i] $dir")
    ((i++))
  done < <(dirs -p)

  if ((${#stack[@]} <= 2)); then
    printf '%s\n' "builtin pushd >/dev/null"
    return
  fi

  local fzf_opts=(
    "--height" "40%"
    "--layout" "reverse"
  )

  local selection
  selection=$(printf '%s\n' "${stack[@]}" | fzf "${fzf_opts[@]}")
  if [[ -n $selection && $selection =~ \[([0-9]+)\] ]]; then
    printf '%s\n' "builtin pushd +${BASH_REMATCH[1]} >/dev/null"
  fi
}

# shellcheck disable=2016
bind -m emacs-standard '"\ev": " \C-b\C-k \C-u`__fzf_pushf__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
# Binding from fzf `ALT_C_COMMAND` Bash binding:
# \C-b\C-k \C-u : clear line
# `__fzf_pushf` : print the pushd command to execute
# \e            : start escape sequence
# \er           : repaint line
# \C-m          : press enter & execute the command
# \C-y          : yank (paste) the last killed text
# \ey           : move back one work
# \C-x\C-x      : swap cursor positions
bind -m vi-command '"\ev": "\C-z\ev\C-z"'
bind -m vi-insert '"\ev": "\C-z\ev\C-z"'

#!/usr/bin/env bash

if ! command -v fzf >/dev/null 2>&1 ||
  ! command -v bat >/dev/null 2>&1; then
  return 1
fi

function v() {
  local fzf_bin="fzf"
  local bat_bin="bat"
  # shellcheck disable=2153
  local bat_theme="${BAT_THEME:-base16}"

  local fzf_opts=(
    "--multi"
    "--preview '$bat_bin --color=always --style=plain --theme=$bat_theme {}'"
    "--height 40%"
    "--layout reverse"
    "--bind=alt-u:preview-page-up,alt-d:preview-page-down"
  )
  local vi_opts=()
  local query=""

  for arg in "$@"; do
    if [[ $arg == -* ]]; then
      vi_opts+=("$arg")
    else
      query+=" $arg"
    fi
  done

  if [ -n "$query" ]; then
    fzf_opts+=("--query" "$query")
  fi

  fzf_opts+=("--bind 'enter:become(vi ${vi_opts[@]} {+})'")

  eval "$fzf_bin ${fzf_opts[*]}"
}

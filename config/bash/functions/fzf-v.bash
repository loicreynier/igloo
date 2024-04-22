function v() {
  local fzf_bin="fzf"
  local bat_bin="bat"

  local fzf_opts=(
    "--multi"
    "--preview '$bat_bin --color=always {}'"
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

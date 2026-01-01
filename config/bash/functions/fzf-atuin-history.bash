if ! command -v fzf >/dev/null 2>&1 ||
  ! command -v atuin >/dev/null 2>&1; then
  return 1
fi

__fzf_atuin_hist_widget() {
  local cmd
  local ret

  local atuin_opts="--cmd-only"
  # shellcheck disable=SC2206
  local fzf_opts=(
    ${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS}
    "--reverse"
    "--no-multi"
    "--tac"            # Reverse input order
    "--tiebreak=index" # Prefer line that appeared earlier in the input stream
    "--query=${READLINE_LINE}"
    "--preview='echo {}'"
    "--preview-window=down:3:hidden:wrap"
    "--header 'Command history'"
  )
  if [[ -n ${SYSTEM_CMD_COPY} ]]; then
    fzf_opts+=("--bind \"ctrl-y:execute-silent(echo -n {1..} | $SYSTEM_CMD_COPY)+abort\"")
  fi

  cmd=$(eval "atuin search ${atuin_opts} | fzf ${fzf_opts[*]}")
  ret=$?

  if [ -n "$cmd" ]; then
    READLINE_LINE="$cmd"
    READLINE_POINT=${#cmd}
  fi

  return $ret
}

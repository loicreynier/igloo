__fzf_atuin_hist_widget() {
  local cmd
  local ret

  local atuin_opts="--cmd-only"
  local fzf_opts=(
    "--height=40%"
    "--reverse"
    "--no-multi"
    "--tac"            # Reverse input order
    "--tiebreak=index" # Prefer line that appeared earlier in the input stream
    "--nth=2.."        # Search from the second field onward, is it necessary?
    "--query=${READLINE_LINE}"
    "--preview='echo {}'"
    "--preview-window=down:3:hidden:wrap"
    "--bind=ctrl-space:toggle-preview"
    "--color=header:italic"
    "--header='Press <CTRL-Space> to preview command'"
  )

  cmd=$(eval "atuin search ${atuin_opts} | fzf ${fzf_opts[*]}")
  ret=$?

  if [ -n "$cmd" ]; then
    READLINE_LINE="$cmd"
    READLINE_POINT=${#cmd}
  fi

  return $ret
}

__atuin_fzf_history_setup() {
  if ! command -v atuin &>/dev/null; then return 1; fi
  export ATUIN_NOBIND="true"
  eval "$(atuin init "bash")"
  bind -x '"\C-r": __fzf_atuin_hist_widget'
  bind -x '"\C-x\C-r": __atuin_history'
}

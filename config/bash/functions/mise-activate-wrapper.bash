#!/usr/bin/env bash

# Modified Bash activation script for mise-en-place (`mise`)
#
# Uses "command mise" instead of hardcoded binary path so that it works
# with a wrapper script (for example, a custom wrapper that runs mise
# with a specific `glibc` installation or environment).
#
# `mise deactivate` does not need modifications as for version 2026.1.1.
#
# This edit could easily patched upstream (see `mise/src/shell/bash.rs`),
# but doing so would add maintenance burden for a very edge-case usage.

if [[ -v HAS[mise] ]]; then
  :
elif ! command -v mise >/dev/null 2>&1; then
  return 1
fi

# shellcheck disable=SC2329
__mise_activate_wrapper() {

  export MISE_SHELL=bash

  if [ -z "${__MISE_ORIG_PATH:-}" ]; then
    export __MISE_ORIG_PATH="$PATH"
  fi

  mise() {
    local command
    command="${1:-}"
    if [ "$#" = 0 ]; then
      command mise
      return
    fi
    shift

    case "$command" in
    self-update)
      echo >&2 "Error: 'mise self-update' cannot be run from a wrapper script." \
        "Please update manually"
      return 1
      ;;
    deactivate | shell | sh)
      # shellcheck disable=SC2199
      if [[ ! " $@ " =~ " --help " ]] && [[ ! " $@ " =~ " -h " ]]; then
        eval "$(command mise "$command" "$@")"
        return $?
      fi
      ;;
    esac
    command mise "$command" "$@"
  }

  _mise_hook() {
    local previous_exit_status=$?
    eval "$(mise hook-env -s bash)"
    return $previous_exit_status
  }

  if [[ ";${PROMPT_COMMAND:-};" != *";_mise_hook;"* ]]; then
    PROMPT_COMMAND="_mise_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
  fi

  function __zsh_like_cd() {
    builtin typeset __zsh_like_cd_hook
    if
      builtin "$@"
    then
      for __zsh_like_cd_hook in chpwd "${__chpwd_functions[@]}"; do
        if \typeset -f "$__zsh_like_cd_hook" >/dev/null 2>&1; then
          "$__zsh_like_cd_hook" || break # Finish on first failed hook
        fi
      done
      true
    else
      return $?
    fi
  }

  [[ -n ${ZSH_VERSION:-} ]] ||
    {
      function cd() { __zsh_like_cd cd "$@"; }
      function popd() { __zsh_like_cd popd "$@"; }
      function pushd() { __zsh_like_cd pushd "$@"; }
    }

  export -a __chpwd_functions
  __chpwd_functions+=(_mise_hook)

  _mise_hook

  if [ -z "${_mise_cmd_not_found:-}" ]; then
    _mise_cmd_not_found=1
    if [ -n "$(declare -f command_not_found_handle)" ]; then
      _mise_cmd_not_found_handle=$(declare -f command_not_found_handle)
      eval "${_mise_cmd_not_found_handle/command_not_found_handle/_command_not_found_handle}"
    fi

    command_not_found_handle() {
      if [[ $1 != "mise" && $1 != "mise-"* ]] && command mise hook-not-found -s bash -- "$1"; then
        _mise_hook
        "$@"
      elif [ -n "$(declare -f _command_not_found_handle)" ]; then
        _command_not_found_handle "$@"
      else
        echo "bash: command not found: $1" >&2
        return 127
      fi
    }
  fi
}

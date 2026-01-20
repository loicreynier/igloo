#!/usr/bin/env bash

# ~/.bashrc

# shellcheck disable=SC1090,SC1091

if [ -n "$__HOME_BASHRC_SOURCED" ]; then return; fi
__HOME_BASHRC_SOURCED=1

[[ $- == *i* ]] || return

if [[ -f "/etc/bashrc" ]]; then
  echo "Sourcing '/etc/bashrc'"
  source "/etc/bashrc"
fi

# == SYSTEM-SPECIFIC INITIALIZATION ================================================================

if [[ $SYSTEM == "HPCC_Vesta" ]]; then
  if [[ -f "/nfs/mesonet/sw/profile/bashrc.default" ]]; then
    echo "Sourcing '/nfs/mesonet/sw/profile/bashrc.default'"
    source "/nfs/mesonet/sw/profile/bashrc.default"
  fi
fi

if [[ $SYSTEM == "HPCC_Turpan" ]]; then
  if [[ -n $VNCDESKTOP ]]; then
    export PATH="$HOME/.local/binx86":"$PATH"
  fi
fi

# == UTILITY FUNCTIONS AND VARIABLES ===============================================================

declare -A HAS
for cmd in bat comma direnv eza fd fzf git just mise nvim \
  pass pyenv python3 starship stowsh vim zoxide; do
  command -v "$cmd" >/dev/null && HAS[$cmd]=1
done

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
data_dirs=(
  "$HOME/.nix-profile/share"
  "${XDG_STATE_HOME-$HOME/.local/state}/nix/profiles/profile/share"
  "${XDG_DATA_HOME-$HOME/.local/share}"
)
profile_dirs=(
  "$HOME/.nix-profile/etc/profile.d"
  "$HOME/.local/etc/profile.d"
)

# == BASH OPTIONS ==================================================================================

HISTFILE="$state_dir/bash_history"
HISTCONTROL=ignoredups:ignorespace:erasedups
HISTFILESIZE=1000
HISTIGNORE='?:??:pwd:clear:tree:history:exit:pass*'

shopt -s "autocd"     # Treat command as `cd` argument if command is a path
shopt -s "cdspell"    # Fix spelling while `cd`-ing
shopt -s "checkjobs"  # Prevent exiting if jobs are running
shopt -s "direxpand"  # Expand `~` paths and more during completion
shopt -s "dirspell"   # Fix dir names during completion
shopt -s "dotglob"    # Globbing also includes dotfiles
shopt -s "extglob"    # Enable advanced pattern matching
shopt -s "globstar"   # Enable `**` for subdirectory globbing
shopt -s "histappend" # Append to history file instead of overwriting it

# == ALIASES =======================================================================================

alias mv="mv -i"
alias cp="cp -i"
# alias rm="rm -i"

alias ls="ls --color=auto"
alias l="l -lha"
alias ll="ls -lh"
alias la="ls -a"
alias lla="ls -lha"
alias l.="ls -d .*"
alias ll.="ls -lhd .*"
alias lrt="ls -rt"
alias llrt="ls -lhrt"
alias lt="tree"

alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."

# shellcheck disable=SC2290,2285
alias +="pushd"
alias -- -="popd"
alias +1="pushd +1"
alias +2="pushd +2"
alias +3="pushd +3"

case "$SYSTEM" in
"ONERA_workstation")
  if [[ -v HAS[pass] ]]; then
    alias ssh-olympe="pass -c srv/olympe && ssh -X olympe"
    alias ssh-topaze="PASSWORD_STORE_CLIP_TIME=60 pass -c srv/topaze && ssh -X topaze"
  fi
  ;;
"HPCC_Vesta")
  alias salloc="salloc -A m23003 -p mn-grant"
  alias salloc2g="salloc --gres=gpu:2"
  ;;
esac

# == CUSTOM FUNCTIONS ==============================================================================

path() {
  # IFS = Internal Field Separator
  local IFS=':'
  local -a path_array

  read -r -a path_array <<<"${1:-$PATH}"

  for element in "${path_array[@]}"; do
    echo "$element"
  done
}

_setup_bash_functions() {
  for file in "${XDG_CONFIG_HOME:-$HOME/.config}/bash/functions"/*.bash; do
    [ -f "$file" ] && source "$file"
  done
}
_setup_bash_functions

# == SOFTWARE SETUP ================================================================================

_setup_bash_completion() {
  if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
    for profile_dir in "${profile_dirs[@]}"; do
      source="$profile_dir/bash_completion.sh"
      [[ -f $source ]] && source "$source"
      break
    done
  fi
}

_setup_bash_command_not_found() {
  for profile_dir in "${profile_dirs[@]}"; do
    source="$profile_dir/command-not-found.sh"
    [[ -f $source ]] && source "$source"
    if [[ ${HAS[comma]} ]]; then
      source="$profile_dir/comma-command-not-found.sh"
      [[ -f $source ]] && source "$source"
    fi
    break
  done
}

_setup_bash_git() {
  alias groot='cd $(git rev-parse --show-toplevel)'
}

_setup_bash_vim() {
  alias vi="vim"
}

_setup_bash_nvim() {
  alias vim="nvim"
}

_setup_bash_eza() {
  unset LS_COLORS
  eza_flags="--git --color=auto --icons=auto"
  if [[ $SYSTEM == "HPCC_Turpan" ]] && [[ -n $VNCDESKTOP ]]; then
    eza_flags="--git --color=auto"
  fi
  # shellcheck disable=2139
  alias eza="eza $eza_flags"
  alias ls="eza"
  alias l="ls -lba"
  alias l1="ls -1"
  alias ll="ls -lb"
  alias la="ls -a"
  alias lla="ls -lba"
  alias l.="ls -d .*"
  alias ll.="ls -lbd .*"
  alias lrt="ls -snew"
  alias llrt="ls -lbsnew"
  alias lt="ls --tree"
  alias tree="ls --tree"
  unset eza_flags
}

_setup_bash_bat() {
  alias bat='bat --theme=${BAT_THEME:-base16}'
  alias cat='bat --style=plain --paging=never'
}

_setup_bash_fd() {
  alias fd="fd --hidden --follow" # Can be ignored with `--no-hidden` and `--no-follow`
}

_setup_bash_python3() {
  alias python="python3"
  alias pip-install-offline="python3 -m pip install --user --no-index --no-build-isolation"
  alias pip-uninstall-all='python3 -m pip freeze --user --exclude-editable \
    | cut -d "@" -f1 \
    | xargs pip uninstall -y'
}

_setup_bash_stowsh() {
  alias stowsh-local='stowsh -t $HOME/.local'
}

_setup_bash_just() {
  alias j="just"
  alias ji="just --choose"
}

_setup_bash_fzf() {
  if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
    eval "$(command fzf --bash)"
  fi

  local fzf_preview_files
  local fzf_preview_dirs
  local fzf_preview_cmd

  if [[ ${HAS[bat]} ]]; then
    fzf_preview_files="bat --color=always --style=plain"
  else
    fzf_preview_files="head -n 50"
  fi
  if [[ ${HAS[eza]} ]]; then
    fzf_preview_dirs="eza -a
    --icons --no-quotes --group-directories-first
    --color=always --color-scale-mode=fixed"
  else
    fzf_preview_dirs="ls -al"
  fi

  # fzf options cannot be configured in `.profile` otherwise they are overwritten
  export FZF_DEFAULT_OPTS="--prompt='❯ '
  --height 40%
  --bind='f1:toggle-header'
  --bind='f2:toggle-preview'
  --bind 'alt-u:preview-page-up,alt-d:preview-page-down'
  --color header:italic"
  if [[ ${HAS[fd]} ]]; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --strip-cwd-prefix"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow --strip-cwd-prefix"
  fi
  export FZF_CTRL_T_OPTS="--reverse --multi --preview '${fzf_preview_files} {}'"
  export FZF_ALT_C_OPTS="--reverse --preview '${fzf_preview_dirs} {}'"
  export FZF_CTRL_R_OPTS="--preview 'echo {}'
  --preview-window down:3:hidden:wrap
  --reverse
  --header 'Command history'"

  if [ -n "${SYSTEM_CMD_COPY}" ]; then
    FZF_CTRL_R_OPTS="$FZF_CTRL_R_OPTS \
      --bind \"ctrl-y:execute-silent(echo -n {2..} | $SYSTEM_CMD_COPY)+abort\""
  fi

  export FZF_TAB_COMPLETION_PROMPT="❯ "
  export FZF_COMPLETION_AUTO_COMMON_PREFIX=true

  for data_dir in "${data_dirs[@]}"; do
    source="$data_dir/fzf-tab-completion/bash/fzf-bash-completion.sh"
    if [[ -f $source ]]; then
      source "$source"
      _fzf_bash_completion_loading_msg() { echo "$FZF_TAB_COMPLETION_PROMPT"; }
      bind -x '"\t": fzf_bash_completion'
      break
    fi
  done

  export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS
  --no-multi --no-sort --scheme=path --exit-0 --select-1
  --preview '${fzf_preview_dirs} {2..}'"

  if [[ ${HAS[bat]} ]]; then
    fzf_preview_cmd="just --show {} | ${fzf_preview_files} --language=Just"
  else
    fzf_preview_cmd="just --show {}"
  fi
  export JUST_CHOOSER="fzf --reverse --preview '${fzf_preview_cmd}' || false"
}

_setup_bash_direnv() {
  eval "$(command direnv hook bash)"
}

_setup_bash_pyenv() {
  eval "$(command pyenv init -)" && eval "$(command pyenv virtualenv-init -)"
}

_setup_bash_pyenv_from_lazy() {
  unset -f pyenv python python3 pip pip3
  _setup_bash_pyenv
}

_setup_bash_pyenv_lazy() {
  # Unfortunately `shfmt` doesn't let me write them as one-liners...
  pyenv() {
    _setup_bash_pyenv_from_lazy
    pyenv "$@"
  }

  python() {
    _setup_bash_pyenv_from_lazy
    python "$@"
  }

  python3() {
    _setup_bash_pyenv_from_lazy
    python3 "$@"
  }

  pip() {
    _setup_bash_pyenv_from_lazy
    pip "$@"
  }

  pip3() {
    _setup_bash_pyenv_from_lazy
    pip3 "$@"
  }
}

_setup_bash_mise() {
  if [[ ${__mise_wrapper:-0} -eq 1 ]] && declare -F __mise_activate_wrapper >/dev/null; then
    __mise_activate_wrapper
  else
    eval "$(command mise activate bash)"
  fi
}

_setup_bash_starship() {
  [[ $TERM != "dumb" ]] && eval "$(command starship init bash)"
}

_setup_bash_starship_from_lazy() {
  # Starship init overrides `$PROMPT_COMMAND`
  PROMPT_COMMAND="${PROMPT_COMMAND/_setup_bash_starship_from_lazy;/}"
  PROMPT_COMMAND="${PROMPT_COMMAND//_setup_bash_starship_from_lazy/}"
  local prompt_cmd_bak=$PROMPT_COMMAND
  _setup_bash_starship
  [[ -n $prompt_cmd_bak ]] && PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}$prompt_cmd_bak"
}

_setup_bash_starship_lazy() {
  PROMPT_COMMAND="_setup_bash_starship_from_lazy${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
}

_setup_bash_zoxide() {
  eval "$(command zoxide init bash)"
}

_setup_bash_zoxide_lazy() {

  z() {
    unset -f z zi
    _setup_bash_zoxide
    z "$@"
  }

  zi() {
    unset -f z zi
    _setup_bash_zoxide
    zi "$@"
  }
}

_setup_bash_atuin() {
  for data_dir in "${data_dirs[@]}"; do
    source="$data_dir/bash/bash-preexec.sh"
    if [[ -f $source ]]; then
      source "$source"
      eval "$(ATUIN_NOBIND=1 command atuin init "bash")"
      bind -x '"\C-x\C-a": __atuin_history'
      if declare -F __fzf_atuin_hist_widget >/dev/null; then
        bind -x '"\C-x\C-r": __fzf_atuin_hist_widget'
      fi
      break
    fi
  done
}

[[ -v HAS[git] ]] && _setup_bash_git
[[ -v HAS[vim] ]] && _setup_bash_vim
[[ -v HAS[nvim] ]] && _setup_bash_nvim
[[ -v HAS[eza] ]] && _setup_bash_eza
[[ -v HAS[bat] ]] && _setup_bash_bat
[[ -v HAS[fd] ]] && _setup_bash_fd
[[ -v HAS[python3] ]] && _setup_bash_python3
[[ -v HAS[stowsh] ]] && _setup_bash_stowsh
[[ -v HAS[just] ]] && _setup_bash_just
[[ -v HAS[fzf] ]] && _setup_bash_fzf
[[ -v HAS[starship] ]] && _setup_bash_starship # Starship init overrides `$PROMPT_COMMAND`
[[ -v HAS[direnv] ]] && _setup_bash_direnv
[[ -v HAS[pyenv] ]] && _setup_bash_pyenv_lazy
[[ -v HAS[mise] ]] && _setup_bash_mise
[[ -v HAS[zoxide] ]] && _setup_bash_zoxide_lazy
# FIXME: `atuin init bash || echo $?` returns 1 on Latios (not tested elsewhere)
# Atuin preexec setup may be incompatible with other loaded
# [[ -v HAS[atuin] ]] && _setup_bash_atuin

_setup_bash_completion
_setup_bash_command_not_found

# == CLEANING ======================================================================================

unset state_dir data_dirs data_dir profile_dirs profile_dir source

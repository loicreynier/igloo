#!/usr/bin/env bash

# ~/.bashrc

if [ -f /etc/bashrc ]; then
  # shellcheck disable=SC1091
  . /etc/bashrc
fi

# -- Utility functions and variables

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"

# -- TurboVNC hack

if [[ -n $VNCDESKTOP ]]; then
  if [[ $SYSTEM == "HPCC_Turpan" ]]; then
    export PATH="$HOME/.local/binx86":"$PATH"
  fi
fi

# -- Bash options

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

# -- Aliases

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

command_exists "git" && alias groot='cd $(git rev-parse --show-toplevel)'

command_exists "vim" && alias vi="vim"
command_exists "nvim" && alias vim="nvim"

if command_exists "bat"; then
  alias bat='bat --theme=${BAT_THEME:-base16}'
  alias cat='bat --style=plain --paging=never'
fi

if command_exists "eza"; then
  eza_flags="--git --color=auto --icons=auto"
  if [[ $SYSTEM == "HPCC_Turpan" ]] && [[ -n "$VNCDESKTOP" ]]; then
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
fi

if command_exists "python3"; then
  alias python="python3"
  # NOTE: `no-build-isolation` doesn't seem to work with `--force-reinstall`
  alias pip-install-offline="python3 -m pip install --user --no-index --no-build-isolation"
  # editorconfig-checker-disable-next-line
  alias pip-uninstall-all='python3 -m pip freeze --user --exclude-editable | cut -d "@" -f1 | xargs pip uninstall -y'
fi

command_exists "stowsh" && alias stowsh-local='stowsh -t $HOME/.local'

case "$SYSTEM" in
"ONERA_workstation")
  if command_exists "pass"; then
    alias ssh-olympe="pass -c srv/olympe && ssh -X olympe"
    alias ssh-topaze="PASSWORD_STORE_CLIP_TIME=60 pass -c srv/topaze && ssh -X topaze"
  fi
  ;;
esac

# -- Software setup

command_exists "direnv" && eval "$(direnv hook bash)"
if command_exists "fzf"; then 
  eval "$(fzf --bash)"
  if [[ -f "$XDG_DATA_HOME/fzf-tab-completion/bash/fzf-bash-completion.sh" ]]; then
    source "$XDG_DATA_HOME/fzf-tab-completion/bash/fzf-bash-completion.sh"
    bind -x '"\t": fzf_bash_completion'
  fi
fi
command_exists "pyenv" && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"
command_exists "starship" && eval "$(starship init bash --print-full-init)"
command_exists "zoxide" && eval "$(zoxide init bash)"

# -- Custom functions

for file in "$config_dir/bash/functions"/*.bash; do
  # shellcheck disable=SC1090
  [ -f "$file" ] && source "$file"
done

# -- Cleaning

unset state_dir config_dir
unset -f command_exists

#!/usr/bin/env bash

# ~/.bashrc

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# -- Utility functions and variables

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"

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
alias l.="ls -d .*"
alias ll="ls -l"
alias lrt="ls -lrt"

command_exists "git" && alias groot='cd $(git rev-parse --show-toplevel)'

command_exists "vim" && alias vi="vim"
command_exists "nvim" && alias vim="nvim"

command_exists "bat" && alias cat="bat --paging=never"

if command_exists "eza"; then
  alias eza="eza --group-directories-first --color=auto --icons=auto"
  alias ls="eza"
  alias lrt="eza -l -snew"
  alias tree="eza --tree"
fi

if command_exists "python3"; then
  alias python="python3"
  # NOTE: `no-build-isolation` doesn't seem to work with `--force-reinstall`
  alias pip-install-offline="python3 -m pip install --user --no-index --no-build-isolation"
  alias pip-uninstall-all='pip freeze --exclude-editable | cut -d "@" -f1 | xargs pip uninstall -y'
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
command_exists "fzf" && eval "$(fzf --bash)"
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

#!/usr/bin/env bash

# ~/.bashrc

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

command_exists "vim" && alias vi="vim"
command_exists "nvim" && alias vim="nvim"

if command_exists "eza"; then
  alias ls="eza"
  alias lrt="eza -l -snew"
fi

command_exists "python3" && alias python="python3"
command_exists "stowsh" && alias stowsh-local='stowsh -t $HOME/.local'

# -- Software setup

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

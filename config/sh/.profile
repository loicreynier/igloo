#!/usr/bin/env sh

# ~/.profile

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

[ -z "$UID" ] && UID="$(id -u)"
[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname)"

# == SYSTEM RECOGNITION ========================================================

# This script uses the `SYSTEM` variable to recognize different systems.
# Bash (and other software) configuration depend on the value of `SYSTEM`,
# which is determined based on the hashed machine ID from `hostnamectl`,
# or the hashed hostname if recognized.
# Once the system if recognized, a list of options `SYSTEM_OPTIONS` is set up.

# Try to determine system from `hostnamectl`'s machine ID
if command -v hostnamectl >/dev/null 2>&1; then
  system_id=$(hostnamectl | grep 'Machine ID' | awk '{print $3}')
  system_id=$(printf "%s" "$system_id" | sha256sum | awk '{print $1}')

  case "$system_id" in
  "6b1a62a469cfe86e197f5a04746504696971733f8ad47978a04dcbf26cad1cd2")
    SYSTEM="ONERA_workstation"
    ;;
  *)
    SYSTEM="unknown"
    ;;
  esac

  if [ "$SYSTEM" = "unknown" ]; then
    echo "System not recognized from hardware"
  else
    echo "System recognized from hardware as: '$SYSTEM'"
  fi

  unset system_id
else
  echo "System not recognized from hardware: 'hostnamectl' not found"
fi

# Automatically determine system based on hostname if not recognized
if [ "$SYSTEM" = "unknown" ]; then
  hostname_sha=$(printf "%s" "$HOSTNAME" | sha256sum | awk '{print $1}')

  case "$hostname_sha" in
  "120d48ac77121271bd444cf4c93769ba6d6f36b3c6228c61949c5a25a40f1b5a")
    SYSTEM="ONERA_workstation"
    ;;
  *)
    SYSTEM="unknown"
    ;;
  esac

  case "$HOSTNAME" in
  ldmpe*)
    SYSTEM="ONERA_workstation"
    ;;
  olympe*)
    SYSTEM="HPCC_Olympe"
    ;;
  topaze*)
    SYSTEM="HPCC_Topaze"
    ;;
  *)
    SYSTEM="unknown"
    ;;
  esac

  if [ "$SYSTEM" = "unknown" ]; then
    echo "System not recognized from hostname"
  else
    echo "System recognized from hostname as: '$SYSTEM'"
  fi

  unset hostname
fi

# Set system options depending on the value of `SYSTEM`
case "$SYSTEM" in
"ONERA_workstation")
  SYSTEM_OPTIONS="offline"
  ;;
*)
  SYSTEM_OPTIONS=""
  ;;
esac

export SYSTEM
export SYSTEM_OPTIONS

# == ENVIRONMENT VARIABLES =====================================================

# -- System configuration

export PATH="$HOME/.local/bin":"$PATH"

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

if command_exists "nvim"; then
  export EDITOR=nvim
  export TERMINAL=nvim
  export SUDO_EDITOR=nvim
elif command_exists "vim"; then
  export EDITOR=vim
  export TERMINAL=vim
  export SUDO_EDITOR=vim
fi

[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_SATE_HOME" ] && export XDG_STATE_HOME="$HOME/.local/state"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_RUNTIME_DIR" ] && export XDG_RUNTIME_DIR="/run/user/$UID"

# -- Software configuration

export INPUTRC="$HOME/.inputrc"
export PASSWORD_STORE_DIR="$HOME/.local/share/password-store"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"

# == SHELL CONFIGURATION =======================================================

if [ "$0" = "-bash" ] || [ "$0" = "/bin/bash" ] && [ -n "$PS1" ]; then
  echo "Sourcing '${HOME}/.bashrc'"
  # shellcheck disable=SC1091
  . "${HOME}/.bashrc"
fi

# Shell setups are stored as functions so then can be loaded manually
# if system is not automatically recognized

_setup_shell_ONERA_workstation() {
  module purge
  module load -s python/3.12.2-gnu850
  export PATH="$PATH":"/tmp_user/$HOSTNAME/$USER/local/bin"
}

_setup_shell_HPCC_Olympe() {
  module purge
  module load -s python/3.11.3
  clear
}

_setup_shell_HPCC_Topaze() {
  module load -s python/3.11.4
}

case "$SYSTEM" in
"ONERA_workstation") _setup_shell_ONERA_workstation ;;
"HPCC_Olympe") _setup_shell_HPCC_Olympe ;;
"HPCC_Topaze") _setup_shell_HPCC_Topaze ;;
esac

# == RICING ====================================================================

[ -z "$SYSTEM_THEME" ] && export SYSTEM_THEME="base16"

case "$SYSTEM_THEME" in
"base16")
  export BAT_THEME=base16
  ;;
esac

# == CLEANING ==================================================================

unset -f command_exists

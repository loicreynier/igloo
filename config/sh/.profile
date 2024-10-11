#!/usr/bin/env sh

# ~/.profile

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
  hostname=$(printf "%s" "$HOSTNAME" | sha256sum | awk '{print $1}')

  case "$hostname" in
  "120d48ac77121271bd444cf4c93769ba6d6f36b3c6228c61949c5a25a40f1b5a")
    SYSTEM="ONERA_workstation"
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

export PATH="$PATH":"$HOME/.local/bin"

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

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

if [ "$0" = "-bash" ] && [ -n "$PS1" ]; then
  echo "Sourcing '${HOME}/.bashrc'"
  # shellcheck disable=SC1091
  . "${HOME}/.bashrc"
fi

case "$SYSTEM" in
"ONERA_workstation")
  module purge
  module load python/3.12.2-gnu850
  export PATH="$PATH":"/tmp_user/$HOSTNAME/$USER/local/bin"
  ;;
esac

#!/usr/bin/env sh

# ~/.profile

# shellcheck disable=SC1091

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

if [ -z "$SYSTEM" ]; then
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
    turpanvisu*)
      SYSTEM="HPCC_Turpan_visu"
      ;;
    turpan*)
      SYSTEM="HPCC_Turpan"
      GPG_TTY="$(tty)"
      export GPG_TTY
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

  export SYSTEM
fi

if [ -z "$SYSTEM_OPTIONS" ]; then
  # Set system options depending on the value of `SYSTEM`
  case "$SYSTEM" in
  "ONERA_workstation")
    SYSTEM_OPTIONS="${SYSTEM_OPTIONS:+$SYSTEM_OPTIONS:}offline"
    ;;
  "HPCC_"*)
    SYSTEM_OPTIONS="${SYSTEM_OPTIONS:+$SYSTEM_OPTIONS:}hpcc"
    ;;
  esac

  export SYSTEM_OPTIONS
fi

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

export BASH_COMPLETION_USER_DIR="$XDG_DATA_HOME/bash-completion/"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export TEXMFHOME="$XDG_DATA_HOME/texmf"

export LESSHISTFILE="$XDG_STATE_HOME/lesshst"

export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"

if [ -d "$HOME/.local/opt/pyenv" ]; then
  export PYENV_ROOT="$HOME/.local/opt/pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

if [ -d "$HOME/.local/opt/cargo" ]; then
  export CARGO_HOME="$HOME/.local/opt/cargo"
  export PATH="$CARGO_HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/opt/rustup" ]; then
  export RUSTUP_HOME="$HOME/.local/opt/rustup"
fi

if [ -d "$HOME/.local/lib/perl5" ]; then
  export PERL5LIB="$HOME/.local/lib/perl5"
fi

# == SHELL CONFIGURATION =======================================================

if [ "$0" = "-bash" ] ||
  [ "$0" = "/bin/bash" ] ||
  [ "$0" = "bash" ] &&
  [ -n "$PS1" ]; then
  if [ -f "$HOME/.local/etc/profile.d/bash_completion.sh" ]; then
    unset BASH_COMPLETION_VERSINFO # Unset if already loaded by `/etc/profile.d`
    echo "Sourcing '~/.local/etc/profile.d/bash_completion.sh'"
    . "$HOME/.local/etc/profile.d/bash_completion.sh"
  elif [ -f /etc/profile.d/bash_completion.sh ]; then
    echo "Sourcing '/etc/profile.d/bash_completion.sh'"
    . /etc/profile.d/bash_completion.sh
  fi
  if [ -f "${HOME}/.bashrc" ]; then
    echo "Sourcing '${HOME}/.bashrc'"
    . "${HOME}/.bashrc"
  fi
fi

# Shell setups are stored as functions so then can be loaded manually
# if system is not automatically recognized

_setup_shell_ONERA_workstation() {
  export PATH="$HOME/.bin":"$PATH"

  module -s purge
  module -s load cmake/3.29.3
  module -s load gcc/14.2.0
  module -s load python/3.12.2-gnu850
  module -s load firefox
}

_setup_shell_HPCC_Olympe() {
  module -s purge
  module -s load cmake/3.30.3
  module -s load gcc/12.3.0
  module -s load python/3.11.3
  export CC=gcc
}

_setup_shell_HPCC_Turpan() {
  module -s load cmake/3.25.1
  module -s load gnu/12.2.0
  module -s load python/3.10.9
}

_setup_shell_HPCC_Turpan_visu() {
  export PATH="$HOME/.local/binx86":"$PATH"
}

_setup_shell_HPCC_Topaze() {
  module -s load cmake/default
  module -s load gcc/14.2.0
  module -s load python/3.11.4
}

case "$SYSTEM" in
"ONERA_workstation") _setup_shell_ONERA_workstation ;;
"HPCC_Olympe") _setup_shell_HPCC_Olympe ;;
"HPCC_Turpan") _setup_shell_HPCC_Turpan ;;
"HPCC_Turpan_visu") _setup_shell_HPCC_Turpan_visu ;;
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

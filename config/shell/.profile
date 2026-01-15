#!/usr/bin/env sh

# ~/.profile

# shellcheck disable=SC1091

if [ -n "$__HOME_PROFILE_SOURCED" ]; then return; fi
__HOME_PROFILE_SOURCED=1

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

log() {
  [ -n "$PS1" ] &&
    # [ -n "$__HOME_PROFILE_DEBUG" ] &&
    printf '%s\n' "$*"
}

if command_exists "sha256sum"; then
  hash_cmd="sha256sum"
elif command_exists "shasum"; then
  hash_cmd="shasum -a 256"
else
  hash_cmd=""
fi

hash256() {
  if [ -n "$hash_cmd" ]; then
    $hash_cmd | awk '{print $1}'
  else
    return 1
  fi
}

path_prepend() {
  [ -n "$1" ] || return 0
  [ -d "$1" ] || return 0
  case ":$PATH:" in
  *":$1:"*) ;;
  *) PATH="$1:$PATH" ;;
  esac
}

[ -z "$UID" ] && UID="$(id -u)"
[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname)"

# == SYSTEM RECOGNITION ========================================================

# This script uses the `SYSTEM` variable to recognize different systems.
# Bash (and other software) configuration depend on the value of `SYSTEM`,
# which is determined based on the hashed machine ID from `/etc/machine-id`
# or `hostnamectl`, or the hashed hostname if recognized.
# Once the system if recognized, a list of options `SYSTEM_OPTIONS` is set up.

if [ -z "$SYSTEM" ]; then
  SYSTEM="unknown"

  if [ -n "$hash_cmd" ]; then
    system_id=""

    # First try to determine system from `/etc/machine-id`
    if [ -r /etc/machine-id ]; then
      if system_id=$(cat /etc/machine-id | hash256); then
        :
      else
        system_id=""
      fi
    # ... then try from `hostnamectl`'s machine ID (slower)
    elif command_exists "hostnamectl"; then
      if system_id=$(cat /etc/machine-id | hash256); then
        :
      else
        system_id=""
      fi
    else
      log "System not recognized from hardware:" \
        "'/etc/machine-id' or 'hostnamectl' not found"
    fi

    case "$system_id" in
    "6b1a62a469cfe86e197f5a04746504696971733f8ad47978a04dcbf26cad1cd2")
      SYSTEM="workstation_ONERA"
      ;;
    esac

    if [ "$SYSTEM" = "unknown" ]; then
      log "System not recognized from hardware"
    else
      log "System recognized from hardware as: '$SYSTEM'"
    fi

    unset system_id
  fi

  # Automatically determine system based on hostname if not recognized before
  if [ "$SYSTEM" = "unknown" ]; then
    hostname_sha=$(printf "%s" "$HOSTNAME" | hash256)

    case "$hostname_sha" in
    "120d48ac77121271bd444cf4c93769ba6d6f36b3c6228c61949c5a25a40f1b5a")
      SYSTEM="workstation_ONERA"
      ;;
    *)
      case "$HOSTNAME" in
      latios)
        SYSTEM="laptop_Latios"
        ;;
      ldmpe*)
        SYSTEM="workstation_ONERA"
        ;;
      olympe*)
        SYSTEM="HPCC_Olympe"
        ;;
      turpanvisu*)
        SYSTEM="HPCC_Turpan_visu"
        ;;
      turpan*)
        SYSTEM="HPCC_Turpan"
        ;;
      topaze*)
        SYSTEM="HPCC_Topaze"
        ;;
      hpc-vesta*)
        SYSTEM="HPCC_Vesta"
        ;;
      *)
        SYSTEM="unknown"
        ;;
      esac
      ;;
    esac

    if [ "$SYSTEM" = "unknown" ]; then
      log "System not recognized from hostname"
    else
      log "System recognized from hostname as: '$SYSTEM'"
    fi

    unset hostname_sha
  fi

  export SYSTEM
fi

if [ -z "$SYSTEM_OPTIONS" ]; then
  # Set system options depending on the value of `SYSTEM`
  case "$SYSTEM" in
  "laptop_Latios")
    SYSTEM_OPTIONS="${SYSTEM_OPTIONS:+$SYSTEM_OPTIONS:}laptop:nix"
    ;;
  "workstation_ONERA")
    SYSTEM_OPTIONS="${SYSTEM_OPTIONS:+$SYSTEM_OPTIONS:}workstation:offline"
    ;;
  "HPCC_Topaze")
    SYSTEM_OPTIONS="${SYSTEM_OPTIONS:+$SYSTEM_OPTIONS:}hpcc:offline:slow"
    ;;
  "HPCC_"*)
    SYSTEM_OPTIONS="${SYSTEM_OPTIONS:+$SYSTEM_OPTIONS:}hpcc"
    ;;
  esac

  grep -qi microsoft /proc/version 2>/dev/null &&
    SYSTEM_OPTIONS="${SYSTEM_OPTIONS:+$SYSTEM_OPTIONS:}wsl"

  export SYSTEM_OPTIONS
fi

if [ -z "$SYSTEM_CMD_COPY" ]; then
  case "$SYSTEM" in
  "laptop_Latios")
    command_exists "wl-copy" && SYSTEM_CMD_COPY="wl-copy"
    ;;
  esac

  export SYSTEM_CMD_COPY
fi

if [ -z "$SYSTEM_CMD_PASTE" ]; then
  case "$SYSTEM" in
  "laptop_Latios")
    command_exists "wl-paste" && SYSTEM_CMD_PASTE="wl-paste"
    ;;
  esac

  export SYSTEM_CMD_PASTE
fi

# == RICING ====================================================================

[ -z "$SYSTEM_THEME" ] && export SYSTEM_THEME="base16"

case "$SYSTEM_THEME" in
"base16")
  export BAT_THEME=base16
  ;;
esac

# == ENVIRONMENT VARIABLES =====================================================

# -- System configuration

path_prepend "$HOME/.local/bin"

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
[ -z "$XDG_STATE_HOME" ] && export XDG_STATE_HOME="$HOME/.local/state"
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_RUNTIME_DIR" ] && export XDG_RUNTIME_DIR="/run/user/$UID"

# -- Software configuration

if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

export BASH_COMPLETION_USER_DIR="$XDG_DATA_HOME/bash-completion/"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"

export GNUPGHOME="$HOME/.gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export TEXMFHOME="$XDG_DATA_HOME/texmf"

export _ZO_DATA_DIR="$XDG_STATE_HOME"

export LESSHISTFILE="$XDG_STATE_HOME/lesshst"

export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export GOPATH="$XDG_DATA_HOME/go"
export GOCACHE="$XDG_CACHE_HOME/go/build"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"

export PYENV_ROOT="$HOME/.local/opt/pyenv"
path_prepend "$PYENV_ROOT/bin"

export MISE_DATA_DIR="$HOME/.local/opt/mise"

export CARGO_HOME="$HOME/.local/opt/cargo"
export RUSTUP_HOME="$HOME/.local/opt/rustup"
path_prepend "$CARGO_HOME/bin"

if [ -d "$HOME/.local/lib/perl5" ]; then
  export PERL5LIB="$HOME/.local/lib/perl5"
fi

# -- User environment variables

if [ -d "$HOME/igloo" ]; then
  export NH_FLAKE="$HOME/igloo"
  export IGLOO="$HOME/igloo"
fi

# == SHELL CONFIGURATION =======================================================

if [ -n "$PS1" ] &&
  { [ "$0" = "-bash" ] || [ "$0" = "/bin/bash" ] || [ "$0" = "bash" ]; }; then
  if [ -f "$HOME/.local/etc/profile.d/bash_completion.sh" ]; then
    unset BASH_COMPLETION_VERSINFO # Unset if already loaded by `/etc/profile.d`
    log "Sourcing '~/.local/etc/profile.d/bash_completion.sh'"
    . "$HOME/.local/etc/profile.d/bash_completion.sh"
  elif [ -f /etc/profile.d/bash_completion.sh ]; then
    log "Sourcing '/etc/profile.d/bash_completion.sh'"
    . /etc/profile.d/bash_completion.sh
  fi
  if [ -f "${HOME}/.bashrc" ]; then
    log "Sourcing '${HOME}/.bashrc'"
    . "${HOME}/.bashrc"
  fi
fi

# Shell setups are stored as functions so then can be loaded manually
# if system is not automatically recognized

_setup_shell_workstation_ONERA() {
  path_prepend "$HOME/.bin"

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
  GPG_TTY="$(tty)"
  export GPG_TTY
  module -s load cmake/3.25.1
  module -s load gnu/12.2.0
  module -s load python/3.10.9
}

_setup_shell_HPCC_Turpan_visu() {
  path_prepend "$HOME/.local/binx86"
}

_setup_shell_HPCC_Topaze() {
  module -s load cmake/default
  module -s load gcc/14.2.0
  module -s load python/3.11.4
}

_setup_shell_HPCC_Vesta() {
  GPG_TTY="$(tty)"
  export GPG_TTY
}

case "$SYSTEM" in
"workstation_ONERA") _setup_shell_workstation_ONERA ;;
"HPCC_Olympe") _setup_shell_HPCC_Olympe ;;
"HPCC_Turpan") _setup_shell_HPCC_Turpan ;;
"HPCC_Turpan_visu") _setup_shell_HPCC_Turpan_visu ;;
"HPCC_Topaze") _setup_shell_HPCC_Topaze ;;
"HPCC_Vesta") _setup_shell_HPCC_Vesta ;;
esac

# == CLEANING ==================================================================

export PATH # Required as `path_prepend` doesn't export

unset -f command_exists log hash256 path_prepend
unset hash_cmd

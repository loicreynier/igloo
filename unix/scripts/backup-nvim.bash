#!/usr/bin/env bash

the_name="backup-nvim"

print_usage() {
  echo "Usage: $the_name {backup [data|config|lazy]|restore <backup-file>}"
}

check_commands() {
  local required_commands=("realpath" "hostname" "tar")

  for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Error: '$cmd' is required but not installed."
      return 1
    fi
  done

  return 0
}

if ! check_commands; then
  exit 1
fi

data_source=$(realpath -s --relative-to "$HOME" "${XDG_DATA_HOME:-$HOME/.local/share}/nvim")
config_source=$(realpath -s --relative-to "$HOME" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim")
lazy_source="$data_source/lazy"
backup_dir="$HOME/Archives/Backups"

backup() {
  mkdir -p "$backup_dir"

  archive_name="neovim_${SYSTEM:-$(hostname)}_$(date +"%Y%m%d_%H%M%S")"

  if [ "$1" = "data" ]; then
    tar_targets=("$data_source")
    archive_name="${archive_name}_data"
  elif [ "$1" = "config" ]; then
    tar_targets=("$config_source")
    archive_name="${archive_name}_config"
  elif [ "$1" = "lazy" ]; then
    tar_targets=("$lazy_source")
    archive_name="${archive_name}_lazy"
  else
    tar_targets=("$data_source" "$config_source")
  fi

  archive_path="$backup_dir/$archive_name.tar.gz"

  if tar -czf "$archive_path" -C "$HOME" "${tar_targets[@]}"; then
    echo "Backup of Neovim data created successfully: '$archive_path'"
  else
    echo "Error: Failed to create backup."
    exit 1
  fi
}

restore() {
  if [ -z "$1" ]; then
    echo "Error: No backup file specified."
    exit 1
  fi

  backup_file="$1"

  if [ ! -f "$backup_file" ]; then
    echo "Error: Backup file $backup_file does not exist."
    exit 1
  fi

  backup

  rm -rf "$data_source" "$config_source"

  if tar -xzf "$backup_file" -C "$HOME" "$data_source" "$config_source"; then
    echo "Neovim data restored successfully from '$backup_file'"
  else
    echo "Error: Failed to restore from backup."
    exit 1
  fi
}

if [ "$#" -eq 0 ]; then
  print_usage
  exit 1
fi

case "$1" in
backup)
  if [ -n "$2" ]; then
    if [ "$2" = "data" ] || [ "$2" = "config" ] || [ "$2" = "lazy" ]; then
      backup "$2"
    else
      print_usage
      exit 1
    fi
  else
    backup
  fi
  ;;
restore)
  if [ -n "$2" ]; then
    restore "$2"
  else
    echo "Error: No backup file specified"
    print_usage
    exit 1
  fi
  ;;
*)
  print_usage
  exit 1
  ;;
esac

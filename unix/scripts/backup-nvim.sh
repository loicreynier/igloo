#!/usr/bin/env bash

data_source="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
config_source="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
backup_dir="$HOME/Archives/Backups"
archive_name="neovim_${SYSTEM:-$(hostname)}_$(date +"%Y%m%d_%H%M%S").tar.gz"
archive_path="$backup_dir/$archive_name"

backup() {
  mkdir -p "$backup_dir"

  if tar -czf "$archive_path" -C "$HOME" \
    ".local/share/nvim" ".config/nvim"; then
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
  echo "Usage: $0 {backup|restore <backup_file>}"
  exit 1
fi

case "$1" in
backup)
  backup
  ;;
restore)
  restore "$2"
  ;;
*)
  echo "Usage: $0 {backup|restore <backup-file>}"
  exit 1
  ;;
esac

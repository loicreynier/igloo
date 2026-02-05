#!/usr/bin/env bash

if ! command -v xdg-open >/dev/null 2>&1; then
  return 1
fi

__xdg_open_clean_logs() {
  find "$log_dir" -name "*.log" -type f -mmin +"$log_max_age_minutes" -delete 2>/dev/null
}

xdg-open() {
  if [[ $# -eq 0 ]]; then
    command xdg-open --help
    return 1
  fi

  if [[ $1 == "--help" || $1 == "-h" ]]; then
    command xdg-open --help
    return 0
  fi

  local log_dir log_file log_max_age_minutes
  log_dir="${XDG_CACHE_HOME:-$HOME/.cache}/xdg-open/logs"
  log_file="$log_dir/$(date +%Y%m%d_%H%M%S).log"
  log_max_age_minutes=60
  # command -v notify-send >/dev/null 2>&1 && notify_on_error=true

  mkdir -p "$log_dir"
  __xdg_open_clean_logs &

  if command xdg-open "$@" >"$log_file" 2>&1; then
    echo "Opened: $* | Logs saved to: $log_file" >&2
    return 0
  else
    # if [[ $notify_on_error == true ]]; then
    #   notify-send --urgency=critical "xdg-open failed" "Check logs in $log_file"
    # fi
    echo "Error: Failed to open '$*' | Logs: $log_file" >&2
    return 1
  fi
}

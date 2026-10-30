#!/usr/bin/env bash

if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
    _usage_bgreen=$'\e[1;32m'
    _usage_bcyan=$'\e[1;36m'
    _usage_cyan=$'\e[36m'
    _usage_bred=$'\e[1;31m'
    _usage_nocolor=$'\e[0m'
else
    _usage_bgreen=''
    _usage_bcyan=''
    _usage_cyan=''
    _usage_bred=''
    _usage_nocolor=''
fi

_usage_opt_width=${_usage_opt_width:-30}

_usage_usage() {
  printf "%sUsage:%s %s%s %s%s\n" \
    "$_usage_bgreen" "$_usage_nocolor" "$_usage_bcyan$1$_usage_nocolor" "$_usage_cyan" "$2" "$_usage_nocolor"
}

_usage_section() {
  printf "%s%s%s\n" "$_usage_bgreen" "$1" "$_usage_nocolor"
}

_usage_opt() {
  # $1 = short option ("" if none)
  # $2 = long option ("" if none)
  # $3 = param ("" if none)
  # $4 = description
  local short=$1
  long=$2
  param=$3
  desc=$4
  local pad=0
  local display=''

  case $short in
  '') ;;
  *) display="${_usage_bcyan}${short}${_usage_nocolor}" ;;
  esac
  case $long in
  '') ;;
  *)
    [ -n "$short" ] && display="${display}${_usage_nocolor}, "
    display="${display}${_usage_bcyan}${long}${_usage_nocolor}"
    ;;
  esac
  case $param in
  '') ;;
  *)
    display="${display} ${_usage_cyan}${param}${_usage_nocolor}"
    pad=1
    ;;
  esac

  width=$((${#short} + ${#long} + ${#param} + pad))
  [[ -n $short ]] && [[ -n $long ]] && width=$((width + 2)) # ", "

  printf '  %s%*s%s\n' "$display" "$((_usage_opt_width - width))" '' "$desc"
}

_usage_error() {
  printf '%sError:%s %s\n' "$_usage_bred" "$_usage_nocolor" "$1"
}

print_error() {
  _usage_error "$1" >&2
}

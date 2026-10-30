#!/usr/bin/env sh

_usage_color() {
  case $1 in
  bgreen) printf '\033[1;32m' ;;
  bcyan) printf '\033[1;36m' ;;
  cyan) printf '\033[36m' ;;
  bred) printf '\033[1;31m' ;;
  nocolor) printf '\033[0m' ;;
  esac
}

_usage_opt_width=${_usage_opt_width:-30}

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    _usage_bgreen=$(_usage_color bgreen)
    _usage_bcyan=$(_usage_color bcyan)
    _usage_cyan=$(_usage_color cyan)
    _usage_bred=$(_usage_color bred)
    _usage_nocolor=$(_usage_color nocolor)
else
    _usage_bgreen=''
    _usage_bcyan=''
    _usage_cyan=''
    _usage_bred=''
    _usage_nocolor=''
fi

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
  __usage_short=$1
  __usage_long=$2
  __usage_param=$3
  __usage_desc=$4
  __usage_pad=0
  __usage_display=''

  case $__usage_short in
  '') ;;
  *) __usage_display="${_usage_bcyan}${__usage_short}${_usage_nocolor}" ;;
  esac
  case $__usage_long in
  '') ;;
  *)
    [ -n "$__usage_short" ] && __usage_display="${__usage_display}${_usage_nocolor}, "
    __usage_display="${__usage_display}${_usage_bcyan}${__usage_long}${_usage_nocolor}"
    ;;
  esac
  case $__usage_param in
  '') ;;
  *)
    __usage_display="${__usage_display} ${_usage_cyan}${__usage_param}${_usage_nocolor}"
    __usage_pad=1
    ;;
  esac

  __usage_width=$((${#__usage_short} + ${#__usage_long} + ${#__usage_param} + __usage_pad))
  [ -n "$__usage_short" ] && [ -n "$__usage_long" ] &&
    __usage_width=$((__usage_width + 2)) # ", "

  printf '  %s%*s%s\n' "$__usage_display" "$((_usage_opt_width - __usage_width))" '' "$__usage_desc"
}

_usage_error() {
  printf '%sError:%s %s\n' "$_usage_bred" "$_usage_nocolor" "$1"
}

print_error() {
  _usage_error "$1" >&2
}



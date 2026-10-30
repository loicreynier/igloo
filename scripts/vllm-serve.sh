#!/usr/bin/env sh

# vLLM server uv-based wrapper script

set -eu

CUDA_HOME="${CUDA_HOME:-${CUDA_PATH:-}}"

clean_jit=0
clean_only=0
jit_cache="${FLASHINFER_WORKSPACE_BASE:-$HOME}/.cache/flashinfer"

# -- Usage "library" and helpers

_usage_name="vllm-serve" # Program name
_usage_opt_width=27      # Longest option width

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



print_help() {
  cat <<EOF
Start a vLLM server in an ephemeral uv-managed environment.

Only supports the Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8 model for now.

Models are downloaded to: ~/.cache/huggingface/hub (may be altered by HF environment variables).
Updating CUDA toolkit versions requires cleaning the JIT cache.

EOF
  print_usage
}

print_usage() {
  _usage_usage "$_usage_name" "[-c | --clean-jit] [--clean-only] [-- <vllm-args]"
  echo
  _usage_section "Options:"
  _usage_opt "-c" "--clean-jit" "" "Delete the FlashInfer JIT cache, then start the server"
  _usage_opt "" "--clean-only" "" "Delete the FlashInfer JIT cache and exit"
  _usage_opt "-h" "--help" "" "Show this help message and exit"
  echo
  _usage_section "Environment:"
  _usage_opt "CUDA_HOME" "" "" "CUDA toolkit root"
  _usage_opt "CUDA_PATH" "" "" "CUDA toolkit root"
  _usage_opt "CUDA_VISIBLE_DEVICES" "" "" "GPU(s)s to use [default: 0]"
  _usage_opt "FLASHINFER_WORKSPACE_BASE" "" "" "JIT cache parent folder [default: ~]"
  echo
  echo 'To pass additional arguments to vLLM, use `--` followed by vLLM arguments.'
  echo
  _usage_section "Examples:"
  echo "  $_usage_name --clean-jit"
  echo "  $_usage_name -- --port 8000 --gpu-memory-utilization 0.80"
  echo
}

# -- Argument parsing

while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    print_help
    exit 0
    ;;
  -c | --clean-jit)
    clean_jit=1
    shift
    ;;
  --clean-only)
    clean_only=1
    clean_jit=1
    shift
    ;;
  --)
    shift
    break
    ;;
  *)
    print_error "unknown option: $1. Use \`--\` to pass extra args to \`vllm\`"
    echo >&2
    print_usage >&2
    exit 1
    ;;
  esac
done

# -- Script

if [ "$clean_jit" -eq 1 ]; then
  if [ -d "$jit_cache" ]; then
    echo "Removing FlashInfer JIT cache: $jit_cache"
    rm -rf "$jit_cache"
  else
    echo "No FlashInfer JIT cache found at: $jit_cache"
  fi
  [ "$clean_only" -eq 1 ] && exit 0
fi

if ! command -v uv >/dev/null 2>&1; then
  print_error '`uv` command not found' >&2
  exit 1
fi

if [ -z "$CUDA_HOME" ]; then
  print_error '`$CUDA_HOME` not set' >&2
  exit 1
fi

export UV_PYTHON=3.12
export UV_NO_PROJECT=1
export UV_TORCH_BACKEND=auto
export HF_HUB_DISABLE_XET=1 # Standard download
export CUDA_DEVICE_ORDER=PCI_BUS_ID
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0}"

set -x
exec uv run --with "vllm" \
  vllm serve Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8 \
  --host 127.0.0.1 \
  --max-model-len 32768 \
  --enable-auto-tool-choice \
  --tool-call-parser qwen3_coder \
  --enable-prefix-caching

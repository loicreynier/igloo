#!/usr/bin/env sh

set -eu

print_help() {
  cat << EOF
Starts a vLLM server in an ephemeral uv-managed environment.

Only supports the Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8 model for now.

Models are downloaded to: ~/.cache/huggingface/hub (may be altered by HF environment variables).
Updating CUDA toolkit versions requires cleaning the JIT cache.

EOF
  print_usage
}

print_usage() {
  cat << EOF
Usage: $(basename "$0") [options] [-- <vllm-args>]

Options:
  -h, --help                  Print this help message and exit
  -c, --clean-jit             Delete the FlashInfer JIT cache, then start the server
      --clean-only            Delete the FlashInfer JIT cache and exit

Environment:
  CUDA_HOME/CUDA_PATH         CUDA toolkit root
  CUDA_VISIBLE_DEVICES        GPU(s) to use (default: 0)
  FLASHINFER_WORKSPACE_BASE   JIT cache parent folder (default: ~)

To pass additional arguments to vLLM, use \`--\` followed by vLLM arguments.

Examples:
  $(basename "$0") --clean-jit
  $(basename "$0") -- --port 8000 --gpu-memory-utilization 0.80
EOF
}

CUDA_HOME="${CUDA_HOME:-${CUDA_PATH:-}}"
clean_jit=0
clean_only=0

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      print_help
    exit 0
    ;;
    -c|--clean-jit)
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
      echo "Error: unknown option: $1. Use \`--\` to pass extra args to \`vllm\`" >&2
      print_usage >&2
      exit 1
      ;;
  esac
done

jit_cache="${FLASHINFER_WORKSPACE_BASE:-$HOME}/.cache/flashinfer"

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
  echo "Error: \`uv\` command not found" >&2
  exit 1
fi

if [ -z "$CUDA_HOME" ]; then
  echo "Error: \`\$CUDA_HOME\` not set" >&2
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

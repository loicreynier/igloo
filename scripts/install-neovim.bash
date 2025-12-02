#!/usr/bin/env bash

DRY_RUN=${DRY_RUN:-0}
REPO=${REPO:-"neovim/neovim"}
TARBALL=${TARBALL:-}
DOWNLOAD_DIR=${SRC_DIR:-$HOME/.local/src}
INSTALL_DIR=${INSTALL_DIR:-$HOME/.local}
TMP_DIR=${TMP_DIR:-$(mktemp -d)}
VERSION=${VERSION:-}
CC=${CC:-}

exit_clean() {
  rm -rf "$TMP_DIR"
  exit "$1"
}

download_release() {
  curl -L -o "$1" "$2"
}

extract_release() {
  tar -xzf "$1" -C "$2" --strip-components=1
}

make_neovim() {
  rm -rf build .deps
  make \
    CMAKE_BUILD_TYPE=Release \
    CMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    ${CC:+CC="\$CC" DEPS_CMAKE_FLAGS="-DCMAKE_C_COMPILER=\$CC"}
  make install
}

# shellcheck disable=SC2016
# editorconfig-checker-disable
print_usage() {
  echo "Usage: $0 [options]"
  echo
  echo "Options:"
  echo "  --dry-run             Perform a dry run (print actions without executing them)"
  echo "  --repo <repo>         Specify the GitHub repository (default: 'neovim/neovim')"
  echo "  --src-dir <dir>       Specify the source (download) directory (default: '\$HOME/.local/src')"
  echo "  --install-dir <dir>   Specify the installation directory (default: '\$HOME/.local')"
  echo '  --tmp-dir <dir>       Specify the temporary directory (default: `mktemp`)'
  echo "  --version <version>   Specify the version to download (default: latest)"
  echo '  --cc <cc>             Specify the C compiler to use (default: determined by `cmake`)'
  echo "  --tarball <path>      Specify the path to a local tarball to use instead of downloading"
  echo "  --help                Display this help message"
  echo
  echo "Examples":
  echo "  $0 --version 0.10.2 --install-dir \$HOME/.local/stow/neovim-0.10.2-olympe --cc gcc"
  exit_clean 0
}
# editorconfig-checker-enable

# -- Argument parser
while [[ $# -gt 0 ]]; do
  case $1 in
  --dry-run) DRY_RUN=1 ;;
  --repo)
    REPO="$2"
    shift
    ;;
  --src-dir)
    DOWNLOAD_DIR="$2"
    shift
    ;;
  --install-dir)
    INSTALL_DIR="$2"
    shift
    ;;
  --tmp-dir)
    TMP_DIR="$2"
    shift
    ;;
  --version)
    VERSION="$2"
    shift
    ;;
  --cc)
    CC="$2"
    shift
    ;;
  --tarball)
    TARBALL="$2"
    shift
    ;;
  --help) print_usage ;;
  *)
    echo "Unknown parameter passed: $1"
    exit_clean 1
    ;;
  esac
  shift
done

# -- Get release info
if [ -z "$TARBALL" ]; then
  if [ -z "$VERSION" ]; then
    echo "-- No version specified, defaulting to latest release"
    release_info="$(curl -s "https://api.github.com/repos/$REPO/releases/latest")"
    src_url=$(echo "$release_info" | awk -F'"' '/tarball_url/{print $4}')
    version_tag=$(echo "$release_info" | awk -F'"' '/tag_name/{print $4}')

    if [ -z "$src_url" ] || [ -z "$version_tag" ]; then
      echo "-- Error: release source or version for GitHub repo \`\$REPO=$REPO\` not found"
      exit_clean 1
    fi
  else
    release_info="$(curl -s "https://api.github.com/repos/$REPO/releases/tags/$VERSION")"
    src_url=$(echo "$release_info" | awk -F'"' '/tarball_url/{print $4}')
    version_tag=$(echo "$release_info" | awk -F'"' '/tag_name/{print $4}')

    if [ -z "$src_url" ]; then
      echo "-- Error: release source version '$VERSION' for GitHub repo \`\$REPO=$REPO\` not found"
      exit_clean 1
    fi
  fi

  src_tar="$TMP_DIR/$(basename "$src_url").tar.gz"
  src_dir="$DOWNLOAD_DIR/neovim-${version_tag#v}"
else
  src_tar="$TARBALL"
  src_dir="$DOWNLOAD_DIR/neovim-local"
fi # [ `-z "$TARBALL` ]

if [[ $DRY_RUN == "1" ]]; then
  echo "-- Dry run info:"
  echo "REPO=$REPO"
  echo "TMP_DIR=$TMP_DIR"
  echo "DOWNLOAD_DIR=$DOWNLOAD_DIR"
  echo "INSTALL_DIR=$INSTALL_DIR"
  echo "CC=$CC"
  echo "TARBALL=$TARBALL"
  echo "src_url=$src_url"
  echo "src_tar=$src_tar"
  echo "src_dir=$src_dir"
fi

[[ $DRY_RUN == "1" ]] && exit_clean 0

mkdir -p "$src_dir"

# -- Download
if [ -z "$TARBALL" ]; then
  if ! download_release "$src_tar" "$src_url"; then
    echo "-- Error: Failed to download the source code"
    exit_clean 1
  else
    echo "-- Source code downloaded to '$src_tar'"
  fi
fi # [ `-z "$TARBALL` ]

# -- Extract
if ! extract_release "$src_tar" "$src_dir"; then
  echo "-- Error: Failed to extract the source code"
  exit_clean 1
else
  echo "-- Info: Source code extracted to '$src_dir'"
fi

echo "-- Cleaning temp directory"
rm -rf "$TMP_DIR"

# -- Make & install
cd "$src_dir" || exit_clean 1
if ! make_neovim; then
  echo "-- Error: failed to compile Neovim"
  exit_clean 1
fi

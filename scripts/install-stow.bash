#!/usr/bin/env bash

TMP_DIR=${TMP_DIR:-$(mktemp -d)}
url=http://ftp.gnu.org/gnu/stow/stow-latest.tar.bz2
tarball=stow-latest.tar.bz2

# Download
cd "$TMP_DIR" || exit 1
curl -O "$url"
version=$(tar -tf "$tarball" | grep -m 1 'stow-[0-9]')
version=${version%/}     # Remove trailing slash
version=${version#stow-} # Remove prefix
install_dir="$HOME/.local/stow/stow-$version"
echo "Installing Stow version $version..."

# Make
[[ -d $install_dir ]] && rm -rf "$install_dir"
cd "stow-$version" || exit 1
./configure --prefix "$install_dir"
make install

# Clean and reorganize for Stow
cd "$install_dir" || exit 1
rm -rf share/doc/stow
mkdir lib
mv -v share/perl5 lib/

# Stow install
cd "$HOME/.local" || exit 1
mkdir -pv bin lib
ln -sfv "../stow/stow-$version/bin/stow" bin/stow
ln -sfv "../stow/stow-$version/lib/perl5" lib/perl5

echo
echo
echo "\`stow\` binary has been stow-installed in '~/.local/bin'"
echo "Run \`stow -R stow-$version\` from '~/.local/stow' to install documentation"

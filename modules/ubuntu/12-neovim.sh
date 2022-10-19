#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

if [ -n "$NVIM_VERSION" ]
then
  version=$NVIM_VERSION
else
  link=$(curl -Ls -o /dev/null -w "%{url_effective}" https://github.com/neovim/neovim/releases/latest)
  echo "$link"
  version="$(echo "$link"  | grep -Po '(?<=/releases/tag/v).*$')"
fi
if [ -z "$version" ]
then
  echo "cannot find version from github."
  exit 1
fi
echo version="$version"

appimage() {
  cd /tmp || exit
  curl -OL "https://github.com/neovim/neovim/releases/download/v$version/nvim.appimage"
  chmod +x nvim.appimage
  sudo mv nvim.appimage /usr/local/bin/nvim
}

build() {
  cd /tmp || exit
  curl -OL "https://github.com/neovim/neovim/archive/refs/tags/v$version.tar.gz"
  tar xf "v$version.tar.gz"
  sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
  cd "neovim-$version" || exit
  make -j4
  sudo make install
}

run() {
  if dpkg --print-architecture | grep -q arm64
  then
    build
  else
    appimage
  fi
}

check() {
  nvim -v 2>&1 | grep -q "NVIM v$version"
}

provision "$@"

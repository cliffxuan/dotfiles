#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum install -y ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch
  cd /tmp || exit 1
  if [ ! -d neovim ]
  then
    if ! hash git 2>/dev/null
    then
      sudo yum install -y git
    fi
    git clone https://github.com/neovim/neovim.git --branch stable
  fi
  cd neovim || exit 1
  make
  sudo make CMAKE_INSTALL_PREFIX=/usr/local install
}


check() {
  nvim -v 2>&1 | grep -q "v0.4."
}


provision "$@"

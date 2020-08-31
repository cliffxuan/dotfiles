#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

version=v0.4.4

run() {
  cd /tmp || exit
  curl -OL https://github.com/neovim/neovim/releases/download/$version/nvim.appimage
  chmod +x nvim.appimage
  sudo mv nvim.appimage /usr/local/bin/nvim
}

check() {
  nvim -v 2>&1 | grep -q $version
}

provision "$@"

#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum install -y make ncurses-devel gcc autoconf man yodl
  cd /tmp || return 1
  curl -L https://sourceforge.net/projects/zsh/files/latest/download -o zsh.tar.xz 
  tar xf zsh.tar.xz
  cd zsh-* || return 1
  ./configure --with-tcsetpgrp
  make -j && sudo make install
}


check() {
  zsh --version 2>&1 | grep -q "zsh 5.7."
}


provision "$@"

#!/usr/bin/env bash
function provision {
  sudo yum install -y make ncurses-devel gcc autoconf man yodl
  cd /tmp || exit 1
  curl -L https://sourceforge.net/projects/zsh/files/latest/download -o zsh.tar.xz 
  tar xf zsh.tar.xz
  cd zsh-* || exit 1
  ./configure --with-tcsetpgrp
  make -j && sudo make install
}


function check {
  zsh --version 2>&1 | grep -q "zsh 5.7."
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi

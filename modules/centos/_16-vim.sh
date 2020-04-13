#!/usr/bin/env bash
# currently disabled because the clipboard doesn't work
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum install -y gcc make ncurses ncurses-devel ctags cmake
  cd /tmp || exit 1
  curl -OL https://ftp.nluug.nl/pub/vim/unix/vim-8.2.tar.bz2
  tar -xjf vim-8.2.tar.bz2
  cd vim82 || exit 1
  ./configure --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-config-dir="$(/usr/local/bin/python3m-config --configdir)" \
    --with-python3-command=/usr/local/bin/python3 \
    --enable-cscope \
    --prefix=/usr/local
      make
      sudo make install
    }


check() {
  vim --version 2>&1 | grep -q "VIM - Vi IMproved 8.2"
}


provision "$@"

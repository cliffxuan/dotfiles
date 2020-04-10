#!/usr/bin/env bash
sudo yum install -y make ncurses-devel gcc autoconf man yodl
cd /tmp
curl -L https://sourceforge.net/projects/zsh/files/latest/download -o zsh.tar.xz 
tar xf zsh.tar.xz
cd zsh-*
./configure --with-tcsetpgrp
make -j && sudo make install

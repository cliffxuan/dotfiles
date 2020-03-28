#!/usr/bin/env bash
yum update -y
yum install -y gcc make ncurses ncurses-devel ctags cmake
cd /tmp
curl -OL https://ftp.nluug.nl/pub/vim/unix/vim-8.2.tar.bz2
tar -xjf vim-8.2.tar.bz2
cd vim82
./configure --with-features=huge \
    --enable-multibyte \
    --enable-python3interp=yes \
    --with-python3-config-dir=$(/usr/local/bin/python3m-config --configdir) \
    --with-python3-command=/usr/local/bin/python3 \
    --enable-cscope \
    --prefix=/usr/local
make
make install

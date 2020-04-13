#!/usr/bin/env bash
sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
cd /tmp
if [ ! -d neovim ]
then
  git clone https://github.com/neovim/neovim.git --branch stable
fi
cd neovim
make
sudo make CMAKE_INSTALL_PREFIX=/usr/local install

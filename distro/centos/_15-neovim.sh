#!/usr/bin/env bash
sudo yum install -y ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch
cd /tmp
if [ ! -d neovim ]
then
  if ! hash git 2>/dev/null
  then
    sudo yum install -y git
  fi
  git clone https://github.com/neovim/neovim.git --branch stable
fi
cd neovim
make
sudo make CMAKE_INSTALL_PREFIX=/usr/local install

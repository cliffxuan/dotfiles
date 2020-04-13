#!/usr/bin/env bash
function provision {
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


function check {
  nvim -v 2>&1 | grep -q "v0.4."
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi

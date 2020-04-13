#!/usr/bin/env bash
version=v0.4.3

function provision {
  cd /tmp || exit
  curl -OL https://github.com/neovim/neovim/releases/download/$version/nvim.appimage
  chmod +x nvim.appimage
  sudo mv nvim.appimage /usr/local/bin/nvim

  # needed for YCM plugin
  sudo yum install -y cmake
}


function check {
  nvim -v 2>&1 | grep -q $version
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  provision
fi

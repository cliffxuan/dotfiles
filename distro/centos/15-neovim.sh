#!/usr/bin/env bash
cd /tmp || exit
curl -OL https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# needed for YCM plugin
sudo yum install -y cmake

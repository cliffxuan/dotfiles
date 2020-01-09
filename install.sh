#!/usr/bin/env bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
# ppa for vim
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update

# install essentials
sudo apt-get -y install build-essential cmake zsh vim curl vim-gtk3 xsel git-lfs
# install nix
curl https://nixos.org/nix/install | sh
source $HOME/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -i tmux nodejs-12.13.1 ripgrep fd inotify-tools fzf

# install python
$BASE_DIR/python/install.sh

# install docker
$BASE_DIR/docker/install.sh

# setup dev environment
$BASE_DIR/kickoff.sh

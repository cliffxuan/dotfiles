#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
# ppa for vim
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update

# install essentials
sudo apt-get -y install build-essential cmake python3-dev zsh vim curl vim-gtk3

# install nix
curl https://nixos.org/nix/install | sh
source $HOME/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -i tmux nodejs-12.13.0 git-lfs ripgrep fd inotify-tools fzf httpie

# install python
PY2_VERSION=2.7.17
PY3_MAJOR=3.8
PY3_MINOR=0
PREFIX=python${PY3_MAJOR}
nix-env -i python-${PY2_VERSION} \
  python3-${PY3_MAJOR}.${PY3_MINOR} $PREFIX-pip \
  $PREFIX-virtualenv $PREFIX-virtualenvwrapper \
  $PREFIX-black $PREFIX-flake8

# install docker
$BASE_DIR/docker/install.sh

# setup dev environment
$BASE_DIR/kickoff.sh

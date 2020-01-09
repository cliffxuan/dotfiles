#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
# ppa for vim
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update

# install vim
sudo apt-get install vim

# node
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y curl zsh build-essential nodejs libffi-dev silversearcher-ag

# git lfs
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:git-core/ppa
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install

# rg
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_amd64.deb
sudo dpkg -i ripgrep_11.0.1_amd64.deb

# fd
cd /tmp; curl -OL https://github.com/sharkdp/fd/releases/download/v7.0.0/fd-musl_7.0.0_amd64.deb; sudo dpkg -i fd-musl_7.0.0_amd64.deb

# install python
$BASE_DIR/python/install.sh

# docker
$BASE_DIR/docker/install.sh
$BASE_DIR/kickoff.sh

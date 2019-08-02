#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
# ppa for vim
sudo add-apt-repository ppa:jonathonf/vim -y
sudo apt-get update

# install vim
sudo apt-get install vim

# node
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y curl zsh build-essential python-dev python3-dev nodejs libffi-dev silversearcher-ag
# python deps
sudo apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev
# lxml deps
sudo apt-get install -y libxml2-dev libxslt-dev
# openssl deps
sudo apt-get install -y libssl-dev libffi-dev

# install python3.7
cd /tmp; curl -O https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz; tar -xf Python-3.7.3.tgz
cd /tmp/Python-3.7.3; ./configure; make; sudo make install
sudo ln -sf /usr/bin/nodejs /usr/bin/node
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
sudo python /tmp/get-pip.py
sudo pip3 install virtualenv virtualenvwrapper pipenv

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
# docker
$BASE_DIR/docker/install.sh
$BASE_DIR/kickoff.sh

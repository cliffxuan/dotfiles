#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

sudo apt-get update
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y curl zsh build-essential python-dev python3-dev nodejs libffi-dev silversearcher-ag
# python deps
sudo apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev zlib1g-dev
# lxml deps
sudo apt-get install -y libxml2-dev libxslt-dev
# openssl deps
sudo apt-get install -y libssl-dev libffi-dev

# install python3.6
cd /tmp; curl -O https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz; tar -xf Python-3.7.0.tgz
cd /tmp/Python-3.7.0; ./configure; make; sudo make install
sudo ln -sf /usr/bin/nodejs /usr/bin/node
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
sudo python /tmp/get-pip.py
sudo pip3 install virtualenv virtualenvwrapper pipenv
$BASE_DIR/kickoff.sh

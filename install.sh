#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

sudo apt-get update
sudo apt-get install -y curl zsh build-essential python-dev python3-dev nodejs npm libffi-dev silversearcher-ag
sudo ln -sf /usr/bin/nodejs /usr/bin/node
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
sudo python /tmp/get-pip.py
sudo pip install virtualenv virtualenvwrapper
$BASE_DIR/kickoff.sh

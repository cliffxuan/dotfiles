#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

apt-get update
apt-get install -y curl zsh build-essential python-dev nodejs npm
ln -sf /usr/bin/nodejs /usr/bin/node
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
python /tmp/get-pip.py
pip install virtualenv virtualenvwrapper
$BASE_DIR/kickoff.sh

#!/usr/bin/env bash
git clone https://github.com/tmux/tmux.git /tmp/tmux
cd /tmp/tmux
sh autogen.sh
sudo yum install -y libevent-devel ncurses-devel automake
./configure && make
sudo make install

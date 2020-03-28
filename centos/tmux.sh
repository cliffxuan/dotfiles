#!/usr/bin/env bash
yum update -y
yum install -y git
git clone https://github.com/tmux/tmux.git /tmp/tmux
cd /tmp/tmux
sh autogen.sh
yum install -y libevent-devel ncurses-devel automake
./configure && make
make install

#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

echo "remove .vim"
rm -rf ~/.vim

echo "remove .vimrc"
rm -rf ~/.vimrc

echo "remove .gitconfig"
rm -rf ~/.gitconfig

echo "remove .oh-my-zsh"
rm -rf ~/.oh-my-zsh

echo "remove .zshrc"
rm -rf ~/.zshrc

echo "remove .bash_it"
rm -rf ~/.bash_it

echo "remove .bash_profile"
rm -rf ~/.bash_profile
echo "added back a minimux bash_profile"
cp $BASE_DIR/bash-it/template/bash_profile.minimum.bash $HOME/.bash_profile

echo "remove .tmux.conf"
rm -rf ~/.tmux.conf

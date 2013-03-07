#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

echo "symlink .zshrc"
ln -s $BASE_DIR/oh-my-zsh/zshrc $HOME/.zshrc

echo "symlink .vimrc"
ln -s $BASE_DIR/vimfiles/_vimrc $HOME/.vimrc

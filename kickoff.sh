#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

echo "checkout submodules"
git submodule init
git submodule update

echo "symlink .zshrc"
ln -fs $BASE_DIR/oh-my-zsh/zshrc $HOME/.zshrc

echo "symlink .vim"
if [ -d "$HOME/.vim" ]
then
    mv $HOME/.vim $HOME/.vimbak_$(date +"%y_%m_%d_%k_%M")
fi
ln -fs $BASE_DIR/vimfiles $HOME/.vim

echo "symlink .vimrc"
ln -fs $BASE_DIR/vimfiles/_vimrc $HOME/.vimrc

echo "checkout vimfiles submodules"
cd $BASE_DIR/vimfiles
git submodule init
git submodule update

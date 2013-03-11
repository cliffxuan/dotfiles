#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

echo "checkout submodules"
git submodule init
git submodule update

echo "symlink .zshrc"
ln -fs $BASE_DIR/oh-my-zsh $HOME/.oh-my-zsh
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

echo "symlink .gitconfig"
ln -fs $BASE_DIR/gitconfig $HOME/.gitconfig

if [[ $SHELL != *zsh* ]]
then
    echo "change default shell to zsh"
    sudo chsh -s $(which zsh) $(whoami)
fi

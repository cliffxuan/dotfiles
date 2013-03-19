#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

if [ $(readlink -f $HOME/.vim) == "$HOME/dotfiles/vimfiles" ]
then
    echo "remove .vim"
    rm -rf ~/.vim
fi

if [ $(readlink -f $HOME/.vimrc) == "$HOME/dotfiles/vimfiles/_vimrc" ]
then
    echo "remove .vimrc"
    rm -rf ~/.vimrc
fi

if [ $(readlink -f $HOME/.gitconfig) == "$HOME/dotfiles/gitconfig" ]
then
    echo "remove .gitconfig"
    rm -rf ~/.gitconfig
fi

if [ $(readlink -f $HOME/.zshrc) == "$HOME/dotfiles/oh-my-zsh/zshrc" ]
then
    echo "remove .zshrc"
    rm -rf ~/.zshrc
fi

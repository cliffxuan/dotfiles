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

if [ $(readlink -f $HOME/.oh-my-zsh) == "$HOME/dotfiles/oh-my-zsh" ]
then
    echo "remove .oh-my-zsh"
    rm -rf ~/.oh-my-zsh
fi

if [ $(readlink -f $HOME/.zshrc) == "$HOME/dotfiles/oh-my-zsh/zshrc" ]
then
    echo "remove .zshrc"
    rm -rf ~/.zshrc
fi

if [ $(readlink -f $HOME/.bash_it) == "$HOME/dotfiles/bash-it" ]
then
    echo "remove .bash_it"
    rm -rf ~/.bash_it
fi

if [ $(readlink -f $HOME/.bash_profile) == "$HOME/dotfiles/bash-it/template/bash_profile.cliff.template.bash" ]
then
    echo "remove .bash_profile"
    rm -rf ~/.bash_profile
    echo "added back a minimux bash_profile"
    cp $BASE_DIR/bash-it/template/bash_profile.minimum.bash $HOME/.bash_profile
fi

if [ $(readlink -f $HOME/.tmux.conf) == "$HOME/dotfiles/tmux.conf" ]
then
    echo "remove .tmux.conf"
    rm -rf ~/.tmux.conf
fi

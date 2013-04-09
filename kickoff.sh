#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

echo "checkout dotfiles submodules"
git submodule init
git submodule update

echo "checkout vim submodules"
cd vimfiles
git submodule init
git submodule update
cd $BASE_DIR


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
vim +BundleInstall +qall

echo "symlink .gitconfig"
ln -fs $BASE_DIR/gitconfig $HOME/.gitconfig

echo "symlink .gitignore_global"
ln -fs $BASE_DIR/gitignore_global $HOME/.gitignore_global

echo "symlink .tmux.conf"
ln -fs $BASE_DIR/tmux.conf $HOME/.tmux.conf

if hash zsh 2>/dev/null
then
    echo "zsh present. set it up."
    echo "symlink .zshrc"
    rm -rf $HOME/.oh-my-zsh
    ln -fs $BASE_DIR/oh-my-zsh $HOME/.oh-my-zsh
    rm -rf $HOME/.zshrc
    ln -fs $BASE_DIR/oh-my-zsh/zshrc $HOME/.zshrc
    if [ $SHELL != *zsh* ]
    then
        echo "change default shell to zsh"
        sudo chsh -s $(which zsh) $(whoami)
    fi
else
    echo "zsh not present. stick with bash."
    echo "symlink .bash_profile"
    rm -rf $HOME/.bash_it
    ln -fs $BASE_DIR/bash-it $HOME/.bash_it
    rm -rf $HOME/.bash_profile
    ln -fs $BASE_DIR/bash-it/template/bash_profile.cliff.template.bash $HOME/.bash_profile
    if [ ! -d "$BASE_DIR/bash-it/completion/enabled" ]
    then
        mkdir "$BASE_DIR/bash-it/completion/enabled"
    fi
    for item in git bash-it ssh defaults
    do
        ln -fs $BASE_DIR/bash-it/completion/available/$item.completion.bash $BASE_DIR/bash-it/completion/enabled/$item.completion.bash
    done
    echo 'run `source ~/.bash_profile` to activate new profile'
fi

#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

echo "symlink .gitconfig"
ln -fs $BASE_DIR/gitconfig $HOME/.gitconfig

echo "symlink .gitignore_global"
ln -fs $BASE_DIR/gitignore_global $HOME/.gitignore_global

echo "symlink .tmux.conf"
ln -fs $BASE_DIR/tmux.conf $HOME/.tmux.conf

echo "symlink .gemrc"
ln -fs $BASE_DIR/gemrc $HOME/.gemrc

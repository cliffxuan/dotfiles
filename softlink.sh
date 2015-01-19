#!/bin/sh
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
SCRIPT_DIR=$BASE_DIR/scripts
DOTFILE_DIR=$BASE_DIR/dotfiles

for DOTFILE in $(ls $DOTFILE_DIR)
do
    echo "symlink .$DOTFILE"
    ln -fs $DOTFILE_DIR/$DOTFILE $HOME/.$DOTFILE
done

for SCRIPT in $(ls $BASE_DIR/scripts)
do
    echo "symlink $SCRIPT"
    ln -fs $SCRIPT_DIR/$SCRIPT $HOME/bin/$SCRIPT
done

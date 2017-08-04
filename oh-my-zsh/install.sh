#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
INSTALL_DIR="$HOME/.oh-my-zsh"

if [[ -d $INSTALL_DIR ]]
then
    echo "oh-my-zsh already installed"
else
    git clone https://github.com/robbyrussell/oh-my-zsh.git $INSTALL_DIR
fi

echo "install $HOME/.zshrc"
ln -fs "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"

echo "install $HOME/.shrc"
ln -fs "$SCRIPT_DIR/../shrc" $HOME/.shrc

echo "install themes"
for themefile in $SCRIPT_DIR/themes/*-theme
do
    echo "$themefile"
    ln -fs "$themefile" "$INSTALL_DIR/themes/"
done

echo "done!"

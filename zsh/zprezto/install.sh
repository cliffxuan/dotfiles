#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
INSTALL_DIR="$HOME/.zprezto"

if [[ -d $INSTALL_DIR ]]
then
    echo "zprezto already installed"
else
    git clone --recursive https://github.com/sorin-ionescu/prezto.git $INSTALL_DIR
fi

echo "install $HOME/.shrc"
ln -fs "$SCRIPT_DIR/../shrc" $HOME/.shrc

for rcfile in zlogin zlogout zshenv zshrc
do
    echo "install $HOME/.${rcfile}"
    ln -fs "$INSTALL_DIR/runcoms/$rcfile" "$HOME/.${rcfile}"
done

for rcfile in zpreztorc  zprofile
do
    echo "install $HOME/.${rcfile}"
    ln -fs "$SCRIPT_DIR/$rcfile" "$HOME/.${rcfile}"
done

echo "done!"

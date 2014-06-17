#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
INSTALL_DIR="$HOME/.zprezto"
for rcfile in zlogin zlogout zshenv zshrc zpreztorc  zprofile
do
    echo "rm $HOME/.$rcfile"
    rm "$HOME/.$rcfile"
done

echo "Done!"

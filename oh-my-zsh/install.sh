#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
INSTALL_DIR="$HOME/.oh-my-zsh"
CUSTOM_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

if [[ -d $INSTALL_DIR ]]
then
    echo "oh-my-zsh already installed"
else
    git clone https://github.com/robbyrussell/oh-my-zsh.git $INSTALL_DIR
fi
if [[ -d $CUSTOM_DIR/plugins/zsh-autosuggestions ]]
then
    echo "zsh-autosuggestions already installed"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions $CUSTOM_DIR/plugins/zsh-autosuggestions
fi

echo "install $HOME/.zshrc"
ln -fs "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"

echo "install $HOME/.shrc"
ln -fs "$SCRIPT_DIR/../shrc" $HOME/.shrc

echo "install themes"
for themefile in $SCRIPT_DIR/themes/*-theme
do
    echo "$themefile"
    ln -fs "$themefile" "$CUSTOM_DIR/themes/"
done
chmod -R o-w,g-w "$CUSTOM_DIR/themes"
chmod -R o-w,g-w "$CUSTOM_DIR/plugins"

echo "done!"

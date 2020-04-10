#!/usr/bin/env bash
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"$BASE_DIR"/softlink.sh

echo "clone vimfiles"
if [ -d "$BASE_DIR/vimfiles" ]
then
    echo "vimfiles alread exists"
else
    git clone git@github.com:cliffxuan/vimfiles "$BASE_DIR"/vimfiles
fi

echo "symlink .vim and .config/nvim"
if [ -d "$HOME/.vim" ] && [ "$(readlink $HOME/.vim)" != "$BASE_DIR/vimfiles" ]
then
    mv $HOME/.vim $HOME/.vimbak_$(date +"%y_%m_%d_%k_%M")
fi
ln -fns $BASE_DIR/vimfiles $HOME/.vim
mkdir -p $HOME/.config
ln -fns $BASE_DIR/vimfiles $HOME/.config/nvim

echo "symlink .vimrc and .config/nvim/init.vim"
ln -fs $BASE_DIR/vimfiles/vimrc $HOME/.vimrc

echo "checkout vimfiles submodules"
cd "$BASE_DIR/vimfiles" || exit
if hash vim 2>/dev/null || hash nvim 2>/dev/null
then
    if [[ $1 != "--no-vim-plugins" ]]
    then
        curl -kfLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        hash vim 2>/dev/null && vim -u "$HOME/.vimrc" -c "try | PlugInstall! | finally | qall! | endtry" -e
        hash nvim 2>/dev/null && nvim -u "$HOME/.vimrc" -c "try | PlugInstall! | finally | qall! | endtry" -e
    fi
else
    echo "vim or nvim not found. install one of them!"
fi

if [ -d "$HOME/.ipython/profile_default/" ]
then
    echo "symlink ipython_config.py"
    ln -fs "$BASE_DIR"/ipython_config.py "$HOME"/.ipython/profile_default/ipython_config.py
fi

if hash zsh 2>/dev/null
then
    echo "zsh present. clone zinit and set it up."
    mkdir -p "$HOME/.zinit"
    if [ -d "$HOME/.zinit/bin" ]
    then
        echo "zinit already exists"
    else
        git clone https://github.com/zdharma/zinit.git "$HOME/.zinit/bin"
    fi
    if [[ "$SHELL" != *"zsh"* ]]
    then
        if sudo chsh -s "$(which zsh)" "$(whoami)"
        then
            echo "changed default shell to zsh"
        else
            echo "unabled to change default shell to zsh"
        fi
    fi
    zsh -c "source $HOME/.zshrc"
fi


if [ ! -d "$HOME/.tmux/plugins/tpm" ]
then
    echo "clone tmux plugin manager"
    mkdir -p "$HOME/.tmux/plugins"
    cd "$HOME/.tmux/plugins" || exit
    git clone https://github.com/tmux-plugins/tpm
    git clone https://github.com/tmux-plugins/tmux-yank
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
fi

#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

$BASE_DIR/softlink.sh

echo "clone vimfiles"
git clone git@github.com:cliffxuan/vimfiles $BASE_DIR/vimfiles

echo "symlink .vim and .config/nvim"
if [ -d "$HOME/.vim" ]
then
    mv $HOME/.vim $HOME/.vimbak_$(date +"%y_%m_%d_%k_%M")
fi
ln -fs $BASE_DIR/vimfiles $HOME/.vim
mkdir -p $HOME/.config
ln -fs $BASE_DIR/vimfiles $HOME/.config/nvim

echo "symlink .vimrc and .config/nvim/init.vim"
ln -fs $BASE_DIR/vimfiles/vimrc $HOME/.vimrc
ln -fs $BASE_DIR/vimfiles/vimrc $HOME/.config/nvim/init.vim

if [[ "$OSTYPE" == "darwin"* ]]
then
    echo "symlink .slate"
    ln -fs $BASE_DIR/slate $HOME/.slate
fi


echo "checkout vimfiles submodules"
cd $BASE_DIR/vimfiles
git submodule init
git submodule update
if hash vim 2>/dev/null
then
    if [[ $1 != "--no-vim-plugins" ]]
    then
        curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim -u $HOME/.vimrc -c "try | PlugInstall! | finally | qall! | endtry" -e
        if hash nvim 2>/dev/null
        then
          nvim -u $HOME/.vimrc -c "try | PlugInstall! | finally | qall! | endtry" -e
        fi
    fi
else
    echo "vim not found. install it!"
fi

if [ -d "$HOME/.ipython/profile_default/" ]
then
    echo "symlink ipython_config.py"
    ln -fs $BASE_DIR/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py
fi

echo "install some common settings shared between bash and zsh"
ln -fs $BASE_DIR/shrc $HOME/.shrc

if hash zsh 2>/dev/null
then
    echo "zsh present. clone oh-my-zsh and set it up."
    $BASE_DIR/oh-my-zsh/install.sh
    if [[ "$SHELL" != *"zsh"* ]]
    then
        if sudo chsh -s $(which zsh) $(whoami)
        then
            echo "changed default shell to zsh"
        else
            echo "unabled to change default shell to zsh"
        fi
    fi
else
    echo "zsh not present. clone bash_it."
    git clone git@github.com:cliffxuan/bash-it.git
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


if [ ! -d "$HOME/.tmux/plugins/tpm" ]
then
    echo "clone tmux plugin manager"
    mkdir -p $HOME/.tmux/plugins
    cd $HOME/.tmux/plugins
    git clone git@github.com:tmux-plugins/tpm.git
    git clone git@github.com:tmux-plugins/tmux-yank.git
fi

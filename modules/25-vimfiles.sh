#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR"/utils.sh
VIMFILES="$BASE_DIR"/vimfiles

run() {
  if [ ! -d "$VIMFILES" ]; then
    git clone git@github.com:cliffxuan/vimfiles "$VIMFILES"
  fi
  echo "symlink .vim and .config/nvim"
  ln -fns "$BASE_DIR"/vimfiles "$HOME"/.vim
  mkdir -p "$HOME"/.config
  ln -fns "$BASE_DIR"/vimfiles "$HOME"/.config/nvim
  echo "symlink vimrc"
  ln -fs "$BASE_DIR"/vimfiles/vimrc "$HOME"/.vimrc
  cd "$VIMFILES" || return 1
  if hash vim 2>/dev/null || hash nvim 2>/dev/null; then
    curl -kfLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if hash vim 2>/dev/null; then
      vim -u "$HOME/.vimrc" -c "try | PlugInstall | finally | qall! | endtry" -e
    fi
    if hash nvim 2>/dev/null; then
      nvim -u "$HOME/.vimrc" -c "try | PlugInstall | finally | qall! | endtry" -es
    fi
  else
    echo "vim or nvim not found. install one of them!"
  fi
}

check() {
  run
}


provision "installed ok!"

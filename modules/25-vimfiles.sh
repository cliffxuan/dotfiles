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
  if hash nvim 2>/dev/null; then
    nvim -c "try | PlugInstall | finally | qall! | endtry" -es
  fi
}

check() {
  run
}


provision "$@"

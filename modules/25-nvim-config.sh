#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR"/utils.sh
NVIM_CONFIG="$BASE_DIR"/nvim-config

run() {
  if [ ! -d "$NVIM_CONFIG" ]; then
    git clone git@github.com:cliffxuan/nvim-config "$NVIM_CONFIG"
  fi
  echo "symlink .vim and .config/nvim"
  ln -fns "$BASE_DIR"/nvim-config "$HOME"/.vim
  mkdir -p "$HOME"/.config
  ln -fns "$BASE_DIR"/nvim-config "$HOME"/.config/nvim
  echo "symlink vimrc"
  ln -fs "$BASE_DIR"/nvim-config/vimrc "$HOME"/.vimrc
  cd "$NVIM_CONFIG" || return 1
}

check() {
  run
}


provision "$@"

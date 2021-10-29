#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR/utils.sh"


run() {
  echo "clone zinit and set it up."
  mkdir -p "$HOME/.zinit"
  if [ -d "$HOME/.zinit/bin" ]
  then
    echo "zinit already exists"
  else
    git clone https://github.com/cliffxuan/zinit.git "$HOME/.zinit/bin"
  fi
  if [[ "$SHELL" != *"zsh"* ]]
  then
    if sudo chsh -s "$(command -v zsh)" "$(whoami)"
    then
      echo "changed default shell to zsh"
    else
      echo "unabled to change default shell to zsh"
    fi
  fi
  zsh -c "source $HOME/.zshrc"
}

check() {
  run
}


provision "$@"

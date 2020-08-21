#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "\$DIR=$DIR"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  DOTFILE_DIR=$(realpath "$DIR"/../dotfiles)
  SCRIPT_DIR="$(realpath "$DIR"/../scripts)"
  echo "\$DIR=$DIR"
  echo "\$DOTFILE_DIR=$DOTFILE_DIR"
  echo "\$SCRIPT_DIR=$SCRIPT_DIR"

  for ff in "$DOTFILE_DIR"/*
  do
    dotfile=$(basename "$ff")
    echo "symlink $DOTFILE_DIR/$dotfile $HOME/.$dotfile"
    ln -fs "$DOTFILE_DIR/$dotfile" "$HOME/.$dotfile"
  done

  mkdir -p "$HOME/bin"
  for ff in "$SCRIPT_DIR"/*
  do
    script=$(basename "$ff")
    echo "symlink $SCRIPT_DIR/$script $HOME/bin/$script"
    ln -fs "$SCRIPT_DIR/$script" "$HOME/bin/$script"
  done
}

check() {
  run
}


provision "$@"

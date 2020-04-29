#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  DOTFILE_DIR=$(realpath "$DIR"/../dotfiles)
  SCRIPT_DIR="$(realpath "$DIR"/../scripts)"

  for ff in "$DOTFILE_DIR"/*
  do
    dotfile=$(basename "$ff")
    echo "symlink .$dotfile"
    ln -fs "$DOTFILE_DIR/$dotfile" "$HOME/.$dotfile"
  done

  mkdir -p "$HOME/bin"
  for ff in "$SCRIPT_DIR"/*
  do
    script=$(basename "$ff")
    echo "symlink $script"
    ln -fs "$SCRIPT_DIR/$script" "$HOME/bin/$script"
  done
}

check() {
  run
}


provision "$@"

#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "\$DIR=$DIR"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  DOTFILE_DIR=$(realpath "$DIR"/../dotfiles)
  SCRIPT_DIR="$(realpath "$DIR"/../scripts)"
  echo "\$DIR=$DIR"
  echo "\$DOTFILE_DIR=$DOTFILE_DIR"
  echo "\$SCRIPT_DIR=$SCRIPT_DIR"

  for ff in "$DOTFILE_DIR"/*; do
    if [ ! -d "$ff" ]; then
      dotfile=$(basename "$ff")
      echo "symlink $DOTFILE_DIR/$dotfile $HOME/.$dotfile"
      ln -fs "$DOTFILE_DIR/$dotfile" "$HOME/.$dotfile"
    fi
  done

  mkdir -p "$HOME/.config"
  for ff in "$DOTFILE_DIR/config"/*; do
    dotfile=$(basename "$ff")
    echo "symlink $DOTFILE_DIR/config/$dotfile $HOME/.config/$dotfile"
    ln -fs "$DOTFILE_DIR/config/$dotfile" "$HOME/.config/$dotfile"
  done

  mkdir -p "$HOME/.local/bin"
  for ff in "$SCRIPT_DIR"/*; do
    script=$(basename "$ff")
    echo "symlink $SCRIPT_DIR/$script $HOME/.local/bin/$script"
    ln -fs "$SCRIPT_DIR/$script" "$HOME/.local/bin/$script"
  done
}

check() {
  run
}

provision "$@"

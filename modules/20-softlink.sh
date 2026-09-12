#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "\$DIR=$DIR"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  DOTFILE_DIR=$(realpath "$DIR"/../dotfiles)
  SCRIPT_DIR="$(realpath "$DIR"/../scripts)"
  CONFIG_DIR=$(realpath "$DIR"/../config)
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
  for ff in "$CONFIG_DIR"/*; do
    name=$(basename "$ff")
    if [ -d "$HOME/.config/$name" ] && [ ! -L "$HOME/.config/$name" ]; then
      (
        shopt -s dotglob nullglob
        for sub in "$ff"/*; do
          subname=$(basename "$sub")
          echo "symlink $sub $HOME/.config/$name/$subname"
          ln -fs "$sub" "$HOME/.config/$name/$subname"
        done
      )
    else
      echo "symlink $CONFIG_DIR/$name $HOME/.config/$name"
      ln -fns "$CONFIG_DIR/$name" "$HOME/.config/$name"
    fi
  done

  mkdir -p "$HOME/.local/bin"
  for ff in "$SCRIPT_DIR"/*; do
    script=$(basename "$ff")
    echo "symlink $SCRIPT_DIR/$script $HOME/.local/bin/$script"
    ln -fs "$SCRIPT_DIR/$script" "$HOME/.local/bin/$script"
  done
}

check() {
  [ -L "$HOME/.zshrc" ] &&
    [ -L "$HOME/.tmux.conf" ] &&
    [ -L "$HOME/.shrc" ]
}

provision "$@"

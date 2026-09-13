#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils.sh
source "$DIR/../utils.sh"

run() {
  local ff dotfile name sub subname script

  for ff in "$DOTFILE_DIR"/*; do
    if [ ! -d "$ff" ]; then
      dotfile=$(basename "$ff")
      echo "symlink $ff $HOME/.$dotfile"
      ln -fs "$ff" "$HOME/.$dotfile"
    fi
  done

  mkdir -p "$HOME/.config"
  for ff in "$CONFIG_DIR"/*; do
    name=$(basename "$ff")
    if [ -d "$HOME/.config/$name" ] && [ ! -L "$HOME/.config/$name" ]; then
      shopt -s dotglob nullglob
      for sub in "$ff"/*; do
        subname=$(basename "$sub")
        echo "symlink $sub $HOME/.config/$name/$subname"
        ln -fs "$sub" "$HOME/.config/$name/$subname"
      done
      shopt -u dotglob nullglob
    else
      echo "symlink $ff $HOME/.config/$name"
      ln -fns "$ff" "$HOME/.config/$name"
    fi
  done

  mkdir -p "$HOME/.local/bin"
  for ff in "$SCRIPT_DIR"/*; do
    script=$(basename "$ff")
    echo "symlink $ff $HOME/.local/bin/$script"
    ln -fs "$ff" "$HOME/.local/bin/$script"
  done
}

check() {
  local ff dotfile name sub subname script

  for ff in "$DOTFILE_DIR"/*; do
    if [ ! -d "$ff" ]; then
      dotfile=$(basename "$ff")
      [ ! -L "$HOME/.$dotfile" ] && return 1
    fi
  done

  for ff in "$CONFIG_DIR"/*; do
    name=$(basename "$ff")
    if [ -d "$HOME/.config/$name" ] && [ ! -L "$HOME/.config/$name" ]; then
      shopt -s dotglob nullglob
      for sub in "$ff"/*; do
        [ -e "$sub" ] || continue
        subname=$(basename "$sub")
        if [ ! -L "$HOME/.config/$name/$subname" ]; then
          shopt -u dotglob nullglob
          return 1
        fi
      done
      shopt -u dotglob nullglob
    else
      [ ! -L "$HOME/.config/$name" ] && return 1
    fi
  done

  for ff in "$SCRIPT_DIR"/*; do
    [ -f "$ff" ] || continue
    script=$(basename "$ff")
    [ ! -L "$HOME/.local/bin/$script" ] && return 1
  done

  return 0
}

provision "$@"

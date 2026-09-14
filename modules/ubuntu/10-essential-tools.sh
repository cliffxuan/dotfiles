#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  zsh
  curl
  xsel
  xclip
  git-lfs
  x11-apps
  xauth
  tree
  tmux
)

run() {
  sudo apt-get -y install "${packages[@]}"
}

check() {
  command -v zsh >/dev/null 2>&1 &&
    command -v curl >/dev/null 2>&1 &&
    command -v git-lfs >/dev/null 2>&1 &&
    command -v tree >/dev/null 2>&1 &&
    command -v tmux >/dev/null 2>&1 &&
    command -v xauth >/dev/null 2>&1 &&
    command -v xsel >/dev/null 2>&1 &&
    command -v xclip >/dev/null 2>&1 &&
    command -v xeyes >/dev/null 2>&1
}

provision "$@"

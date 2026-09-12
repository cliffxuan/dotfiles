#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  zsh
  curl
  git-lfs
  tree
  tmux
  xorg-xauth
  wl-clipboard
  xsel
)

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -S --noconfirm --needed "${packages[@]}"
}

check() {
  command -v zsh >/dev/null 2>&1 &&
    command -v curl >/dev/null 2>&1 &&
    command -v git-lfs >/dev/null 2>&1 &&
    command -v tree >/dev/null 2>&1 &&
    command -v tmux >/dev/null 2>&1 &&
    command -v wl-copy >/dev/null 2>&1 &&
    command -v xsel >/dev/null 2>&1
}

provision "$@"

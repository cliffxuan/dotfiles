#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

packages=(
  docker
  docker-buildx
  docker-compose
)

run() {
  sudo env OMARCHY_ALLOW_DIRECT_PACMAN=1 pacman -S --noconfirm --needed "${packages[@]}"
}

check() {
  command -v docker >/dev/null 2>&1 &&
    command -v docker-compose >/dev/null 2>&1 &&
    docker buildx version >/dev/null 2>&1
}

provision "$@"

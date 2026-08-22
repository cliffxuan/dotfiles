#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR/utils.sh"

user="${1:-$USER}"

run() {
  sudo usermod -aG docker "$user"
  sudo systemctl enable --now docker
}

check() {
  id -nG "$user" 2>/dev/null | grep -qw "docker"
}

provision "$@"

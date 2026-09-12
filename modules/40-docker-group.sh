#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=utils.sh
source "$DIR/../utils.sh"

user="${TARGET_USER:-$USER}"

run() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    return 0
  fi

  sudo usermod -aG docker "$user"
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable --now docker
  fi
}

check() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    return 0
  fi

  id -nG "$user" 2>/dev/null | grep -qw "docker"
}

provision "$@"

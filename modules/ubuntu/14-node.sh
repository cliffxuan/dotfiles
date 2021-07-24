#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

version="${NODE_VERSION:-14}"

run() {
  curl -sL "https://deb.nodesource.com/setup_$version.x" | sudo -E bash -
  sudo apt-get install -y nodejs
}

check() {
  node -v | grep -q "v$version"
}

provision "$@"

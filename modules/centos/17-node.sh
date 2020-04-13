#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
  sudo yum install -y nodejs
}


check() {
  node -v 2>&1 | grep -q "v12."
}


provision "$@"

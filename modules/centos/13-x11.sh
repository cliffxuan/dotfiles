#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum install -y xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps
}


check() {
  run | grep -q "Nothing to do"
}


provision "$@"

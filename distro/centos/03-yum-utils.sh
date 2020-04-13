#!/usr/bin/env bash
# install the yum-utils package (which provides the yum-config-manager utility)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum install -y yum-utils
}


check() {
  run | grep -qE "Package yum-utils-.* already installed and latest version"
}


provision

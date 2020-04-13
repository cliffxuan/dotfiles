#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum groupinstall -y "Development Tools"
}


check() {
  run 2>&1 | grep -q "No packages in any requested group available to install or update"
}


provision "$@"

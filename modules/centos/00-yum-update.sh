#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../../utils.sh
source "$DIR/../../utils.sh"

run() {
  sudo yum update -y
}


check() {
  run | tee -a "$LOG_PATH" | grep -q "No packages marked for update"
}

provision "$@"

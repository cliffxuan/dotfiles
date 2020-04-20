#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$(dirname "$DIR")
# shellcheck source=../utils.sh
source "$BASE_DIR/utils.sh"

if [[ -z $1 ]]
then
  user="$USER"
else
  user=$1
fi

run() {
  sudo usermod -aG docker "$user"
  newgrp docker
}

check() {
  run
}


provision "installed ok!" "$@"
